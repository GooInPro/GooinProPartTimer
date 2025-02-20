import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class kakao_api {


  Future<User?> kakaoLogin() async {

    final User? user;

    try {
      // 카카오톡 앱 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        // 카카오톡이 설치되어 있으면 카카오톡으로 로그인
        try{
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          print("---------------1 login");
          print("카카오톡으로 로그인 성공: ${token.accessToken}");
          user = await UserApi.instance.me();
          return user;
        } catch (error) {
          print("카카오 로그인 실패 1: $error");
        }

      } else {
        try { // 카카오톡이 설치되어 있지 않으면 카카오 계정으로 로그인
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print("---------------2 login");
          print('카카오 계정 로그인 성공: ${token.accessToken}');
          user = await UserApi.instance.me();
          print(user);
          return user;
        } catch(error) {
          print("카카오 로그인 실패 2: $error");
        }

      }
    } catch (error) {
      print("카카오 앱설치 확인 실패: $error");
    }
    return null;
  }

  // Future<Map<String, String>> sendProfile() {
  //
  // }

}