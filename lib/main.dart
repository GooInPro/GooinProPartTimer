import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/routes/app_router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 엔진 초기화
  await dotenv.load(fileName: 'assets/.env');  // .env 파일 로드

  String apiHost = dotenv.env['API_HOST'] ?? 'No API host found';

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