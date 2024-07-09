import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../blocs/home_bloc.dart';
import '../events/home_event.dart';
import '../providers/theme_provider.dart';
import '../states/home_state.dart';
import '../utils/mediaquery.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _orderNow(BuildContext context) async {
    final String userName = FirebaseAuth.instance.currentUser?.email ?? "Anonymous";
    final homeState = context.read<HomeBloc>().state;

    final orderRef = FirebaseFirestore.instance.collection('orders').doc();
    try {
      await orderRef.set({
        'userName': userName,
        'numberOfTanks': homeState.selectedTanks,
        'location': homeState.currentLocationName,
        'latitude': homeState.latitude,
        'longitude': homeState.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQueryHelper = MediaQueryHelper(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
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
                  HapticFeedback.heavyImpact();
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(mediaQueryHelper.scaledWidth(0.05)),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: mediaQueryHelper.scaledHeight(0.1)),
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
                      value: homeState.selectedTanks,
                      dropdownColor: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.black
                          : Colors.white,
                      items: [1, 2, 3, 4]
                          .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Tank(s)'),
                      ))
                          .toList(),
                      onChanged: (value) {
                        context.read<HomeBloc>().add(SelectTanksEvent(value!));
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
                        Text(' ${homeState.selectedTanks * 1000} liters',
                            style: TextStyle(
                                fontSize: mediaQueryHelper.scaledFontSize(0.05)))
                      ],
                    ),
                    SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        _orderNow(context);
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
                Positioned(
                  top: 0,
                  left: mediaQueryHelper.scaledWidth(0),
                  right: mediaQueryHelper.scaledWidth(0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<HomeBloc>().add(UpdateLocationEvent());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              homeState.currentLocationName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: mediaQueryHelper.scaledFontSize(0.04)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}