import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../models/parttimer/parttimer_model.dart';
import '../../../models/jobmatchings/jobmatchings_model.dart';

class PartTimerApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  // 개인정보 조회
  Future<PartTimer> getPartTimerDetail(int pno) async {
    try {
      print('API 서버 주소: $baseUrl'); // API 호스트 확인
      final apiUrl = '$baseUrl/part/detail?pno=$pno';
      print('요청 URL: $apiUrl'); // 요청 URL 확인

      final response = await http.get(Uri.parse(apiUrl));

      print('응답 상태 코드: ${response.statusCode}'); // 응답 상태 코드 확인
      print('응답 데이터: ${response.body}'); // 응답 데이터 확인

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        print('디코딩된 응답 데이터: $decodedResponse'); // 디코딩된 응답 확인
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        return PartTimer.fromJson(jsonResponse);
      } else {
        throw Exception('파트타이머 정보 로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 중 오류 발생: $e'); // 에러 상세 내용 확인
      throw Exception('파트타이머 정보 조회 중 오류 발생: $e');
    }
  }

  // 개인정보 수정
  Future<void> editPartTimerInfo(int pno, PartTimer partTimer) async {
    try {
      final apiUrl = '$baseUrl/part/edit?pno=$pno';
      print('요청 URL: $apiUrl');

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(partTimer.toJson()),
      );

      print('응답 상태 코드: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('파트타이머 정보 수정 실패: ${response.statusCode}');
      }
      print('파트타이머 정보 수정 성공');
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
      throw Exception('파트타이머 정보 수정 중 오류 발생: $e');
    }
  }

  // 계정 삭제
  Future<void> deactivateAccount(int pno) async {
    try {
      final apiUrl = '$baseUrl/part/account/deactivate?pno=$pno';
      print('요청 URL: $apiUrl');

      final response = await http.put(Uri.parse(apiUrl));

      print('응답 상태 코드: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('계정 비활성화 실패: ${response.statusCode}');
      }
      print('계정 비활성화 성공');
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
      throw Exception('계정 비활성화 중 오류 발생: $e');
    }
  }

  // 현재 근무지 조회
  Future<List<JobMatchings>> getCurrentJobs(int pno) async {
    try {
      print('API 서버 주소: $baseUrl');
      final apiUrl = '$baseUrl/log/current?pno=$pno';
      print('요청 URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));

      print('응답 상태 코드: ${response.statusCode}');
      print('응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => JobMatchings.fromJson(json)).toList();
      } else {
        throw Exception('현재 근무지 목록 로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
      throw Exception('현재 근무지 목록 조회 중 오류 발생: $e');
    }
  }

// 과거 근무지 조회
  Future<List<JobMatchings>> getPastJobs(int pno) async {
    try {
      print('API 서버 주소: $baseUrl');
      final apiUrl = '$baseUrl/log/past?pno=$pno';
      print('요청 URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));

      print('응답 상태 코드: ${response.statusCode}');
      print('응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => JobMatchings.fromJson(json)).toList();
      } else {
        throw Exception('과거 근무지 목록 로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
      throw Exception('과거 근무지 목록 조회 중 오류 발생: $e');
    }
  }
}
