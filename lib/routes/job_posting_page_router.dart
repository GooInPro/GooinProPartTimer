import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/JobPostings_page.dart';
import 'package:gooinpro_parttimer/screens/jobpostings_detail_page.dart';

// JobPosting 페이지 라우트 정의
final GoRoute jobPostingPageRoute = GoRoute(
  path: '/',
  builder: (context, state) => JobPostings_page(),
);

final GoRoute jobPostingDetailPageRoute = GoRoute(
    path: '/jobPosting/:jpno',

    builder: (context, state) {
    final jpno = int.parse(state.pathParameters['jpno']!);
    return JobPostingDetailPage(jpno: jpno);
    },
);
