import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/routes/parttimer_page_router.dart';

import '../widget/screen_widget/BottomBar.dart';
import 'chatting_page_router.dart';
import 'in_out_page_router.dart';
import 'job_posting_page_router.dart';
import 'login_page_router.dart';
import 'review_page_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final isLoginPage = state.uri.toString() == '/';
        return MainScreen(child: child, isLoginPage: isLoginPage);
      },
      routes: [
        loginPageRoute,
        jobPostingPageRoute, // jobPostingPage 라우트
        inOutPageRoute,      // inOutPage 라우트
        chatPageRoute,   // chattingPage 라우트
        partTimerPageRoute,
        reviewPageRoute,
      ],
    ),
  ],
);

class MainScreen extends StatelessWidget {
  final Widget child;
  final bool isLoginPage;
  const MainScreen({super.key, required this.child, required  this.isLoginPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: isLoginPage ? null : BottomBar(),
    );
  }
}