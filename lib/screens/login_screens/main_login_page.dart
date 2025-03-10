import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/services/api/loginapi/naver_api.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../models/login/login_model.dart';
import '../../services/api/loginapi/kakao_api.dart';

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {

  final kakao_api kakaoLoginApi = kakao_api();

  final naver_api naverLoginApi = naver_api();

  @override
  void initState() {
    super.initState();
  }

  // onPressed에서 호출되는 함수
  void handleKakaoLogin() async {
      Login? loginuser = await kakaoLoginApi.kakaoLogin();
      if(loginuser != null) {
        context.go('/login/kakaore', extra: loginuser);
      } else {
        print("main login page - 로그인 실패");
      }
    // 여기에 카카오 로그인 기능 추가
  }

  // onPressed에서 호출되는 함수
  void handleNaverLogin() async {
    Login? loginuser = await naverLoginApi.naverLogin();

    if(loginuser != null) {
      context.go('/login/naverre', extra: loginuser);
    } else {
      print("main login page - 로그인 실패");
    }
    // 여기에 카카오 로그인 기능 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: handleKakaoLogin,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // 여백 제거
                minimumSize: Size.zero, // 최소 크기 제거
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
              ),
              child: Image.asset(
                'assets/image/kakao_login.png',
              ),
            ),
            SizedBox(height: 20), // 버튼 간 간격
            TextButton(
              onPressed: handleNaverLogin,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Image.asset(
                'assets/image/naver_login.png',
                width: 200,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}