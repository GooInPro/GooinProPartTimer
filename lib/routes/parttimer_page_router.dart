import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/parttimer_myinfo_page.dart';
import 'package:gooinpro_parttimer/screens/parttimer_worklogs_page.dart';
import 'package:gooinpro_parttimer/screens/parttimer_review_page.dart';

final GoRoute partTimerPageRoute = GoRoute(
  path: '/parttimer',
  builder: (context, state) => PartTimerMyInfoPage(),
  routes: [
    GoRoute(
      path: 'worklogs',
      builder: (context, state) => PartTimerWorkLogsPage(),
    ),
    GoRoute(
      path: 'review',
      builder: (context, state) => PartTimerReviewPage(),
    ),
  ],
);
