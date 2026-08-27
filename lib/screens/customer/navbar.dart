import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerNavBar extends StatelessWidget {
  final int currentIndex;
  const CustomerNavBar({super.key, required this.currentIndex});

  static const green = Color(0xFF2E7D32);

  static const _routes = ['/customer-home', '/search', '/bookings', '/profile'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: green,
      unselectedItemColor: const Color.fromARGB(255, 161, 153, 153),
      currentIndex: currentIndex,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      onTap: (i) {
        if (i != currentIndex) Get.offNamed(_routes[i]);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
