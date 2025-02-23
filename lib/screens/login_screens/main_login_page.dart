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
      backgroundColor: Colors.white, // 배경을 흰색으로 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: handleKakaoLogin, // 카카오 로그인
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Text(
                '카카오 로그인',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(height: 20), // 버튼 간 간격
            ElevatedButton(
              onPressed: handleNaverLogin, // 네이버 로그인
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                '네이버 로그인',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}