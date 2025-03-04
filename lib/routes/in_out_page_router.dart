import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/in_out_screens/in_out_page.dart';

import '../screens/in_out_screens/in_out_work_list_page.dart';

// InOut 페이지 라우트 정의
final GoRoute inOutPageRoute = GoRoute(
  path: '/inoutwork',
  builder: (context, state) => InOutWorkListPage(),
    routes: [
      GoRoute(
          path: 'inout',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final jmno = extra['jmno'] as int? ?? 0;
            final jpno = extra['jpno'] as int? ?? 0;
            return InOutPage(jmno: jmno, jpno: jpno);
          })
    ]
);


//final GoRoute loginPageRoute = GoRoute(
//   path: '/',
//   builder: (context, state) => MainLoginPage(),
//     routes: [
//       GoRoute(
//         path: 'login/kakaore',
//         builder: (context, state) {
//           return KakaoRedirectPage();
//         },
//       ),
//       GoRoute(
//         path: 'login/naverre',
//         builder: (context, state) {
//           return NaverRedirectPage();
//         },
//       ),
//       GoRoute(
//         path: 'register',
//         builder: (context, state) {
//           return RegisterPage();
//         }
//       )
//     ]
// );