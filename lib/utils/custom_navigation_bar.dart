import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(context, 0, Icons.home_filled, 'Home'),
          _buildItem(context, 1, Icons.shopping_cart_rounded, 'Orders'),
          _buildItem(context, 2, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon,
      String label) {
    final bool isSelected = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
        },
        child: Container(
          height: 56.0,
          decoration: BoxDecoration(
            border: isSelected
                ? Border(top: BorderSide(color: selectedItemColor, width: 2.0))
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? selectedItemColor : unselectedItemColor,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? selectedItemColor : unselectedItemColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}