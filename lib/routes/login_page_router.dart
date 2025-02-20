import 'package:go_router/go_router.dart';

import '../screens/login_screens/kakao_redirect_page.dart';
import '../screens/login_screens/main_login_page.dart';


// InOut 페이지 라우트 정의
final GoRoute loginPageRoute = GoRoute(
  path: '/',
  builder: (context, state) => MainLoginPage(),
    routes: [
      GoRoute(
        path: 'login/kakaore',
        builder: (context, state) {
          return KakaoRedirectPage();
        },
      ),
    ]
);
