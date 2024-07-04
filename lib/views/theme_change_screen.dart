import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:water_tanker/views/login_screen.dart';
import '../providers/theme_provider.dart';
import '../utils/tooltip.dart';

class ThemeSwitcherPage extends StatefulWidget {
  const ThemeSwitcherPage({super.key});

  @override
  ThemeSwitcherPageState createState() => ThemeSwitcherPageState();
}

class ThemeSwitcherPageState extends State<ThemeSwitcherPage>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _textColorAnimation;
  late AnimationController _controller;
  OverlayEntry? _tooltipOverlay;
  bool _isTooltipVisible = true;

  @override
  void dispose() {
    _controller.dispose();
    _tooltipOverlay?.remove();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide status bar

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(_controller);

    _textColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(_controller);

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateStatusBarColor();
      _showInitialTooltip();
    });
  }

  void _updateStatusBarColor() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themeProvider.themeMode == ThemeMode.light
          ? Colors.white
          : Colors.black,
      statusBarIconBrightness: themeProvider.themeMode == ThemeMode.light
          ? Brightness.dark
          : Brightness.light,
    ));
  }

  void _showInitialTooltip() {
    _tooltipOverlay = _createTooltipOverlay();
    Overlay.of(context).insert(_tooltipOverlay!);
  }

  OverlayEntry _createTooltipOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 + 60,
        left: MediaQuery.of(context).size.width / 8,
        right: MediaQuery.of(context).size.width / 8,
        child: Material(
          color: Colors.transparent,
          child: ToolTipWidget(
            title: 'Quick Tip',
            description:
            'Click on the icon below to switch between light and dark themes.',
            onClose: _dismissTooltip,
          ),
        ),
      ),
    );
  }

  void _dismissTooltip() {
    _tooltipOverlay?.remove();
    setState(() {
      _isTooltipVisible = false;
    });
  }

  void _goToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _backgroundColorAnimation,
            builder: (context, child) {
              return Container(
                color: _backgroundColorAnimation.value,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                      child: Text(
                        'Select Theme',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _textColorAnimation.value,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            themeProvider.toggleTheme();
                            if (themeProvider.themeMode == ThemeMode.dark) {
                              _controller.reverse();
                            } else {
                              _controller.forward();
                            }
                            _updateStatusBarColor();
                          },
                          child: Icon(
                            themeProvider.themeMode == ThemeMode.light
                                ? Icons.wb_sunny
                                : Icons.nights_stay,
                            size: 100,
                            color: themeProvider.themeMode == ThemeMode.light
                                ? Colors.orange
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: _goToNextScreen,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_isTooltipVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}