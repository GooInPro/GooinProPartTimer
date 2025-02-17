import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/jobpostings_screens/jobpostings_detail_page.dart';
import '../screens/jobpostings_screens/jobpostings_application_register_page.dart';
import '../screens/jobpostings_screens/jobpostings_page.dart';

// JobPosting 페이지 라우트 정의
final GoRoute jobPostingPageRoute =
  GoRoute(
    path: '/jobposting',
    builder: (context, state) => JobPostingsPage(),
    routes: [
      GoRoute(
        path: '/:jpno',
        builder: (context, state) {
          final jpno = int.tryParse(state.pathParameters['jpno'] ?? '') ?? 0;
          print("GoRouter - Navigating to jobPosting detail: $jpno");
          return JobPostingDetailPage(jpno: jpno);
        },
      ),
      GoRoute(
          path: '/application/register',
          builder: (context, state) {
            final jpno = state.extra as int? ?? 0;
            return JobPostingsApplicationRegisterPage(jpno: jpno);
          })
    ]
  );