import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getSelectedIndex(context),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/inout');
            break;
          case 2:
            context.go('/chat');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'JobPosting'),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'In-Out'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatting'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.blue, // 선택된 항목의 색상
      unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 색상
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/inout')) return 1;
    if (location.startsWith('/chat')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}