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
            ElevatedButton(
              onPressed: handleKakaoLogin, // 카카오 로그인
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // 왼쪽, 오른쪽 여백 추가
                child: Image.asset(
                  'assets/image/kakao_login.png',
                ),
              ),
            ),
            SizedBox(height: 20), // 버튼 간 간격
            ElevatedButton(
              onPressed: handleNaverLogin, // 네이버 로그인
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // 왼쪽, 오른쪽 여백 추가
                child: Image.asset(
                  'assets/image/naver_login.png',
                  width: 200, // 원하는 크기로 조절
                  height: 50, // 원하는 크기로 조절
                  fit: BoxFit.contain, // 이미지 비율 유지하며 크기 조정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}