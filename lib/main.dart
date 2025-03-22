import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/providers/user_provider.dart';
import 'package:gooinpro_parttimer/routes/app_router.dart';
import 'package:gooinpro_parttimer/services/api/fcmapi/fcm_api.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 엔진 초기화
  await dotenv.load(fileName: 'assets/.env');  // .env 파일 로드

  String nativeAppKey = dotenv.env['KAKAO_NATIVE_KEY'] ?? '';
  String javascriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_KEY'] ?? '';

  print(nativeAppKey);
  print(javascriptAppKey);
  String apiHost = dotenv.env['API_HOST'] ?? 'No API host found';

  print(await KakaoSdk.origin);

  KakaoSdk.init(
    nativeAppKey: nativeAppKey,
    javaScriptAppKey: javascriptAppKey
  );


  print("main --------------");

  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  print(apiHost);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // UserProvider 등록
      ],
      child: MyApp(apiHost: apiHost),  // API_HOST를 MyApp으로 전달
    ),
  );
}


class MyApp extends StatelessWidget {
  final String apiHost;

  // 생성자에서 API_HOST를 받습니다.
  MyApp({required this.apiHost});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'NanumGothic',
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      routerConfig: appRouter, // go_router 적용
    );
  }
}