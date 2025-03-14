import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/review_screens/review_create_page.dart';
import 'package:gooinpro_parttimer/screens/review_screens/review_mylist_page.dart';
import 'package:gooinpro_parttimer/screens/review_screens/review_jobpostings_page.dart';

final GoRoute reviewPageRoute = GoRoute(
  path: '/review',
  builder: (context, state) => const ReviewMyListPage(), // 기본 경로는 mylist로 설정
  routes: [
    GoRoute(
      path: 'create',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final eno = extra['eno'] as int? ?? 0;
        final ename = extra['ename'] as String? ?? '';
        return ReviewCreatePage(eno: eno, ename: ename);
      },
    ),
    GoRoute(
      path: 'mylist',
      builder: (context, state) => const ReviewMyListPage(),
    ),
    GoRoute(
      path: 'jobpostings/:eno',
      builder: (context, state) {
        final eno = int.parse(state.pathParameters['eno'] ?? '0');
        return ReviewJobPostingsPage(eno: eno);
      },
    ),
  ],
);
