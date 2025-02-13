import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/JobPostings_page.dart';

// JobPosting 페이지 라우트 정의
final GoRoute jobPostingPageRoute = GoRoute(
  path: '/',
  builder: (context, state) => JobPostings_page(),
);
