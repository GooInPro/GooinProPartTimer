import 'package:geolocator/geolocator.dart';

class geolocation_util {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print(" 위치 서비스가 비활성화되었습니다.");
      return null;
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print(" 위치 권한이 영구적으로 거부되었습니다.");
        return null;
      }
    }

    // iOS에서는 권한 확인 후 지연시간을 두고 위치 요청
    await Future.delayed(Duration(milliseconds: 500));

    // 현재 위치 가져오기
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (e) {
      print(" 위치 정보를 가져오는 중 오류 발생: $e");
      return null;
    }
  }
}