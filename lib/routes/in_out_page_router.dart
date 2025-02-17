import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/in_out_screens/in_out_page.dart';

// InOut 페이지 라우트 정의
final GoRoute inOutPageRoute = GoRoute(
  path: '/inout',
  builder: (context, state) => InOutPage(),
);
