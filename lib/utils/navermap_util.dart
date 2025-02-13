import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';


final String? naver_client_id = dotenv.env['NAVER_CLIENT_ID'];

class navermap_util {
  static Completer<NaverMapController> _controller = Completer();


  // NaverMap SDK 초기화
  static Future<void> initializeNaverMap() async {
    await NaverMapSdk.instance.initialize(clientId: naver_client_id);
    print("NaverMap Initialized");
  }

  // Map이 생성된 후 호출되는 콜백 함수
  static void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  // NaverMapController 반환
  static Future<NaverMapController> getController() async {
    return _controller.future;
  }

  static Widget buildNaverMap() {
    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(35.1796, 129.0746), // 초기 위치 설정
          zoom: 10.0, // 초기 확대 비율
        ),
      ),
    );
  }
}