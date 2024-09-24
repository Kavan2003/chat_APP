import 'package:flutter/material.dart';
import 'package:frontend_chat/screens/chatList_screen.dart';
import 'package:frontend_chat/screens/job_screen.dart';
import 'package:frontend_chat/screens/sell_screen.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  // final Function(int) onTap;

  BottomBar({required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChatlistScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const JobScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SellScreen()));

        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
    // onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedIconTheme: const IconThemeData(color: Colors.blue),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Job',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Sell',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
