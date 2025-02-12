import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'JobPosting'),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'In-Out'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatting'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.blue, // 선택된 항목 색상
      unselectedItemColor: Colors.grey, // 선택되지 않은 항목 색상
    );
  }
}