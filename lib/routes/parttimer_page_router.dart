import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_myinfo_page.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_matchinglogs_page.dart';
import 'package:gooinpro_parttimer/screens/partimer_screens/parttimer_review_page.dart';

final GoRoute partTimerPageRoute = GoRoute(
  path: '/parttimer',
  builder: (context, state) => PartTimerMyInfoPage(),
  routes: [
    GoRoute(
      path: 'matchinglogs',  // 경로 이름 변경
      builder: (context, state) => PartTimerMatchingLogsPage(),
    ),
    GoRoute(
      path: 'review',
      builder: (context, state) => PartTimerReviewPage(),
    ),
  ],
);
