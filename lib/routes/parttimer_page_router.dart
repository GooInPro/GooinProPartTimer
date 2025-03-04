import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_myinfo_page.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_matchinglogs_page.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_review_page.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_workdetail_page.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_calendar_page.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';

final GoRoute partTimerPageRoute = GoRoute(
  path: '/parttimer',
  builder: (context, state) => PartTimerMyInfoPage(),
  routes: [
    GoRoute(
      path: 'matchinglogs',
      builder: (context, state) => PartTimerMatchingLogsPage(),
    ),
    GoRoute(
      path: 'workdetail',
      // 참고 https://medium.com/@deerAtJisan/flutter-go-router-state-추가하기-e96c27b372a8
      builder: (context, state) => PartTimerWorkDetailPage(
        jobMatching: state.extra as JobMatchings,
      ),
    ),
    GoRoute(
      path: 'calendar',
      builder: (context, state) => PartTimerCalendarPage(
        jobMatching: state.extra as JobMatchings,
      ),
    ),
    GoRoute(
      path: 'review',
      builder: (context, state) => PartTimerReviewPage(),
    ),
  ],
);
