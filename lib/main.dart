import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/screens/jobpostings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 비동기 초기화 보장
  await dotenv.load(fileName: "assets/.env");  // .env 파일 로드
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    JobPostings_page(),
    Center(child: Text('In-Out Page')),
    Center(child: Text('Chatting Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ), // ✅ 하단바를 추가
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'JobPosting'),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'In-Out'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatting'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}