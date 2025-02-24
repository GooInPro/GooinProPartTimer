import 'package:flutter_naver_login/flutter_naver_login.dart';

import '../../../models/login/login_model.dart';


class naver_api {
  Future<Login> naverLogin() async {
      // 네이버 로그인 요청
      print("---------1");
      final NaverLoginResult res = await FlutterNaverLogin.logIn();
      print("---------2");
      print(res);

        print("네이버 로그인 성공 ------------");
        return Login(
          pemail: res.account.email ?? '',
          pname: res.account.name ?? '',
        );
      }
}