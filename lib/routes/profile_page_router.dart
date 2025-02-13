import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/profile_page.dart';

// Profile 페이지 라우트 정의
final GoRoute profilePageRoute = GoRoute(
  path: '/profile',
  builder: (context, state) => ProfilePage(),
);
