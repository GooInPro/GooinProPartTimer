import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoRedirectPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    // 현재 URL을 가져옵니다.
    final User? user = GoRouter.of(context).state.extra as User?;

    return Scaffold(
      appBar: AppBar(
        title: Text('카카오 리디렉션 페이지'),
      ),
      body: Center(
        child: user != null
            ? user.kakaoAccount?.email != null
            ? Text('User email: ${user.kakaoAccount?.email}, ${user.kakaoAccount?.profile?.nickname}')
            : Text('이메일 정보가 없습니다.') // 이메일이 없을 경우 처리
            : CircularProgressIndicator(), // 로딩 중인 경우 표시
      ),
    );
  }
}