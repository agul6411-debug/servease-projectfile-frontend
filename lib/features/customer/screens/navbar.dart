import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/customer/screens/customerscreen.dart';
import 'package:frontfile_servease/features/customer/screens/provider_list_screen.dart';
import 'package:frontfile_servease/features/customer/screens/my_bookings_screen.dart';
import 'package:frontfile_servease/features/customer/screens/customer_profile_screen.dart';

class CustomerNavBar extends StatelessWidget {
  final int currentIndex;
  const CustomerNavBar({super.key, required this.currentIndex});

  static const green = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: green,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      onTap: (i) {
        if (i == currentIndex) return;
        Widget screen;
        switch (i) {
          case 0:
            screen = const CustomerHomeScreen();
            break;
          case 1:
            screen = const ProvidersListScreen(selectedCategory: 'all');
            break;
          case 2:
            screen = const MyBookingsScreen();
            break;
          case 3:
            screen = const CustomerProfileScreen();
            break;
          default:
            return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => screen),
          (route) => false,
        );
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
