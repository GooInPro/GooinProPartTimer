import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../providers/user_provider.dart';

class BottomBar extends StatelessWidget {

  late UserProvider userProvider; // provider 1




  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getSelectedIndex(context),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/jobposting');
            break;
          case 1:
            context.go('/inoutwork');
            break;
          case 2:
            context.go('/chat');
            break;
          case 3:
            context.go('/parttimer');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: '구인공고'),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: '내 근무'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
      ],
      selectedItemColor: Colors.blue, // 선택된 항목의 색상
      unselectedItemColor: Colors.grey, // 선택되지 않은 항목의 색상
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/inout')) return 1;
    if (location.startsWith('/chat')) return 2;
    if (location.startsWith('/parttimer')) return 3;
    return 0;
  }
}