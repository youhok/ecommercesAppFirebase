import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerces/pages/Order.dart';
import 'package:ecommerces/pages/Profile.dart';
import 'package:ecommerces/pages/home.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentTabIndex = 0;

  // List of pages
  final List<Widget> pages = [
    const Home(),
    const Order(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.grey[200]!, // Matches body background
        color: Colors.black, // Active tab background
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
