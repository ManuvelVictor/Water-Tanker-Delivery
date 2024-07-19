import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tanker/events/theme_event.dart';

import '../blocs/navigation_bloc.dart';
import '../blocs/theme_bloc.dart';
import '../events/navigation_event.dart';
import '../states/navigation_state.dart';
import '../states/theme_state.dart';
import '../utils/custom_bottom_navigation.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final themeStr = userDoc.data()?['theme'] ?? 'ThemeMode.light';
      final themeMode =
          themeStr == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.light;
      context.read<ThemeBloc>().add(SetThemeEvent(themeMode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final bool isDarkMode = themeState.themeMode == ThemeMode.dark;
        final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
        final Color selectedItemColor =
            isDarkMode ? Colors.blueAccent : Colors.blue;
        final Color unselectedItemColor =
            isDarkMode ? Colors.grey : Colors.black;
        return Scaffold(
          body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              if (state is HomeState) {
                return const HomeScreen();
              } else if (state is OrdersState) {
                return const OrdersScreen();
              } else if (state is ProfileState) {
                return const ProfileScreen();
              }
              return Container();
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _getCurrentIndex(context),
            onTap: (index) => _onTabTapped(context, index),
            backgroundColor: backgroundColor,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
          ),
        );
      },
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final state = context.watch<NavigationBloc>().state;
    if (state is HomeState) {
      return 0;
    } else if (state is OrdersState) {
      return 1;
    } else if (state is ProfileState) {
      return 2;
    }
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    final bloc = context.read<NavigationBloc>();
    if (index == 0) {
      bloc.add(NavigateToHome());
    } else if (index == 1) {
      bloc.add(NavigateToOrders());
    } else if (index == 2) {
      bloc.add(NavigateToProfile());
    }
  }
}
