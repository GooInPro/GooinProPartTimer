import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/jobpostings_screens/jobpostings_detail_page.dart';
import '../screens/jobpostings_screens/jobpostings_page.dart';

// JobPosting 페이지 라우트 정의
final List<GoRoute> jobPostingPageRoute = [
  GoRoute(
    path: '/',
    builder: (context, state) => JobPostingsPage(),
  ),
  GoRoute(
    path: '/jobPosting/:jpno',
    builder: (context, state) {
      final jpno = int.tryParse(state.pathParameters['jpno'] ?? '') ?? 0;
      print("GoRouter - Navigating to jobPosting detail: $jpno");
      return JobPostingDetailPage(jpno: jpno);
    },
  ),
];