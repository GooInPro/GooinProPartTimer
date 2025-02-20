import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/routes/app_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
//KAKAO_NATIVE_KEY=dbdfbb3ac76487954c6402e5bee6ca4c
// KAKAO_JAVASCRIPT_KEY=dd8ec49aa7a7c204f2f44478a984df27
void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 엔진 초기화
  await dotenv.load(fileName: 'assets/.env');  // .env 파일 로드

  String nativeAppKey = dotenv.env['KAKAO_NATIVE_KEY'] ?? '';
  String javascriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_KEY'] ?? '';

  print(nativeAppKey);
  print(javascriptAppKey);
  String apiHost = dotenv.env['API_HOST'] ?? 'No API host found';

  KakaoSdk.init(
    nativeAppKey: nativeAppKey,
    javaScriptAppKey: javascriptAppKey
  );



  print("main --------------");
  print(apiHost);

  runApp(
    // MultiProvider(
    //   providers: [ // 상태 관리 provider
    //     ChangeNotifierProvider(create: (_) => PartTimerProvider()),
    //   ],
    //   child:
    MyApp(apiHost: apiHost),  // API_HOST를 MyApp으로 전달
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