import 'dart:async';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class navermap_util {
  static Completer<NaverMapController> _controller = Completer();

  static Future<void> initializeNaverMap() async {
    // 추가적인 초기화 로직이 필요하면 여기에 작성
    print("NaverMap Initialized");
  }

  static void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  static Future<NaverMapController> getController() async {
    return _controller.future;
  }
}