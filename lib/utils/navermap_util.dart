import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

final String? naver_client_id = dotenv.env['NAVER_CLIENT_ID'];

class navermap_util {
  static Completer<NaverMapController> _controller = Completer();
  static List<NMarker> markers = []; // 마커 리스트로 상태 관리

  // NaverMap SDK 초기화
  static Future<void> initializeNaverMap() async {
    await NaverMapSdk.instance.initialize(clientId: naver_client_id);
    print("NaverMap Initialized");
  }

  // Map이 생성된 후 호출되는 콜백 함수
  static void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
    print("Map created and controller initialized.");

    // 이미 추가된 마커가 있다면, 다시 지도에 추가
    markers.forEach((marker) async {
      await controller.addOverlay(marker);
    });
  }

  // NaverMapController 반환
  static Future<NaverMapController> getController() async {
    return _controller.future;
  }

  static Future<void> addMarker(double wlati, double wlong, String jpname) async {
    NaverMapController controller = await getController();

    // 새로운 마커 생성
    final marker = NMarker(
      id: '$jpname-${DateTime.now().millisecondsSinceEpoch}',
      position: NLatLng(wlati, wlong),
    );

    // 마커를 리스트에 추가
    markers.add(marker);

    // 지도에 마커 추가
    await controller.addOverlay(marker);
    print("Added marker at $wlati, $wlong with ID: ${marker}");
  }

  static Widget buildNaverMap() {
    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(35.165949, 129.132658), // 초기 위치 설정
          zoom: 15.0, // 초기 확대 비율
        ),
      ),
      onMapReady: onMapCreated, // onMapCreated 콜백 추가
    );
  }
}