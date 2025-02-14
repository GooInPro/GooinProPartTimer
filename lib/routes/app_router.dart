import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/routes/profile_page_router.dart';

import '../widget/screen_widget/BottomBar.dart';
import 'chatting_page_router.dart';
import 'in_out_page_router.dart';
import 'job_posting_page_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        ...jobPostingPageRoute, // jobPostingPage 라우트
        inOutPageRoute,      // inOutPage 라우트
        chatPageRoute,   // chattingPage 라우트
        profilePageRoute,    // profilePage 라우트
      ],
    ),
  ],
);

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Demo')),
      body: child,
      bottomNavigationBar: BottomBar(),
    );
  }
}