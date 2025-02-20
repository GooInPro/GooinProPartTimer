import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../services/api/loginapi/kakao_api.dart';

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {

  final kakao_api kakaoLoginApi = kakao_api();

  @override
  void initState() {
    super.initState();
  }

  // onPressed에서 호출되는 함수
  void handleKakaoLogin() async {
      User? user = await kakaoLoginApi.kakaoLogin();

      if(user != null) {
        context.go('/login/kakaore', extra: user);
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
        child: ElevatedButton(
          onPressed: handleKakaoLogin, // onPressed에서 handleKakaoLogin 호출
          child: Text(
            '카카오 로그인',
            style: TextStyle(
              color: Colors.black, // 버튼 텍스트 색상
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}