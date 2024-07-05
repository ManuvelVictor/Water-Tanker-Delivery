import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/mediaquery.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedTanks = 1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQueryHelper = MediaQueryHelper(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Water Tanker Delivery",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(mediaQueryHelper.scaledWidth(0.05)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/anim/order_now.json',
                  height: mediaQueryHelper.scaledWidth(0.5),
                  width: mediaQueryHelper.scaledWidth(0.5),
                ),
              ),
              SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
              Text(
                'Select Number of Tanks:',
                style: TextStyle(
                    fontSize: mediaQueryHelper.scaledFontSize(0.05),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: mediaQueryHelper.scaledHeight(0.01)),
              DropdownButton<int>(
                value: _selectedTanks,
                items: [1, 2, 3, 4]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Tank(s)'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTanks = value!;
                  });
                },
              ),
              SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
              Row(
                children: [
                  Text(
                    'Total Capacity:',
                    style: TextStyle(
                        fontSize: mediaQueryHelper.scaledFontSize(0.05),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(' ${_selectedTanks * 1000} liters',
                      style: TextStyle(
                          fontSize: mediaQueryHelper.scaledFontSize(0.05)))
                ],
              ),
              SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
              ElevatedButton(
                onPressed: () {
                  // Handle order placement
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    double.infinity,
                    mediaQueryHelper.scaledHeight(0.07),
                  ),
                ),
                child: Text(
                  'Order Now',
                  style: TextStyle(
                      fontSize: mediaQueryHelper.scaledFontSize(0.05),
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
