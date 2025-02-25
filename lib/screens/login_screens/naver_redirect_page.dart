import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:gooinpro_parttimer/models/login/login_model.dart';

import '../../models/login/login_response_model.dart';
import '../../services/api/loginapi/login_api.dart';
import '../../services/api/loginapi/naver_api.dart';

class NaverRedirectPage extends StatefulWidget {
  @override
  _NaverRedirectPageState createState() => _NaverRedirectPageState();
}


class _NaverRedirectPageState extends State<NaverRedirectPage> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 현재 URL에서 loginuser 값을 가져옵니다.
    final Login? loginuser = GoRouter.of(context).state.extra as Login?;

    if (loginuser != null) {
      _sendLoginData(loginuser);
      // API 호출
    } else {
      setState(() {
        _isLoading = false;  // 로그인 정보가 없을 경우 로딩 화면 종료
      });
    }
  }

  Future<void> _sendLoginData(Login loginuser) async {
    try {
      final loginApi = login_api();
      // API 호출 (비동기 함수)
      LoginResponse response = await loginApi.LoginDataSend(loginuser);

      print("redirect----------");
      print(response);
      if(response == true){
        context.go('/register');
      }
      else{
        context.go('/jobposting');
      }
    } catch (e) {
      // API 호출 실패 시 처리
      print('API 호출 실패 naver reidrect page: $e');
    } finally {
      setState(() {
        _isLoading = false;  // API 호출 완료 후 로딩 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카카오 리디렉션 페이지'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()  // 로딩 중 표시
            : SizedBox.shrink(),  // 로딩이 끝나면 아무것도 표시하지 않음
      ),
    );
  }
}