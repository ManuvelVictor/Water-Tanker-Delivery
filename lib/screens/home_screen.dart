import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _currentLocationName = "Coimbatore";


  Future<void> _orderNow() async {
    final String userName =
        FirebaseAuth.instance.currentUser?.email ?? "Anonymous";
    await _createOrderInFirestore(userName, _selectedTanks);
  }

  Future<void> _createOrderInFirestore(
      String userName, int numberOfTanks) async {
    final orderRef = FirebaseFirestore.instance.collection('orders').doc();

    try {
      await orderRef.set({
        'userName': userName,
        'numberOfTanks': numberOfTanks,
        'location': _currentLocationName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order. Please try again.')),
      );
    }
  }

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
                SizedBox(height: mediaQueryHelper.scaledHeight(0.1)), // Space for location container
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
                    HapticFeedback.mediumImpact();
                    _orderNow();
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
              top: 0, // Align with top of the Stack
              left: mediaQueryHelper.scaledWidth(0.05),
              right: mediaQueryHelper.scaledWidth(0.05),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
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
                        _currentLocationName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: mediaQueryHelper.scaledFontSize(0.04)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}