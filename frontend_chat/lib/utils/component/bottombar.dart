// bottombar.dart
import 'package:flutter/material.dart';
import 'package:frontend_chat/screens/chatList_screen.dart';
import 'package:frontend_chat/screens/job_screen.dart';
import 'package:frontend_chat/screens/profile_screen.dart';
import 'package:frontend_chat/screens/sell_screen.dart';
import 'package:frontend_chat/theme.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;

  BottomBar({required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatListScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JobScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppTheme.surfaceColor,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: AppTheme.accentColor,
      unselectedItemColor: AppTheme.onSurfaceColor.withOpacity(0.7),
      selectedLabelStyle: AppTheme.buttonText,
      unselectedLabelStyle: AppTheme.buttonText.copyWith(
        color: AppTheme.onSurfaceColor.withOpacity(0.7),
      ),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          activeIcon: Icon(Icons.work),
          label: 'Job',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          activeIcon: Icon(Icons.storefront),
          label: 'Sell',
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
