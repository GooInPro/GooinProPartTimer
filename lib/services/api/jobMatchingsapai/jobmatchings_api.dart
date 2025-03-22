import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../models/jobmatchings/jobmatchings_model.dart';

class JobMatchingsApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  // 근무 매칭 ID로 고용주 ID 조회
  Future<int> getEmployerIdByJobMatchingId(int jmno) async {
    try {
      print('API 서버 주소: $baseUrl');
      final apiUrl = '$baseUrl/log/employer/$jmno';
      print('요청 URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));

      print('응답 상태 코드: ${response.statusCode}');
      print('응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        return int.parse(decodedResponse);
      } else {
        throw Exception('고용주 ID 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
      throw Exception('고용주 ID 조회 중 오류 발생: $e');
    }
  }

  // 근무지 상세 조회 (PartTimerApi에서 이동)
  Future<JobMatchings> getJobDetail(int jmno) async {
    try {
      final apiUrl = '$baseUrl/log/detail?jmno=$jmno';
      print('요청 URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));
      print('응답 상태 코드: ${response.statusCode}');
      print('응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(decodedResponse);
        return JobMatchings.fromJson(json);
      } else {
        throw Exception('근무지 상세 정보 로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 중 오류 발생: $e');
      throw Exception('근무지 상세 정보 조회 중 오류 발생: $e');
    }
  }

  // 현재 근무지 조회 (PartTimerApi에서 이동)
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

  // 과거 근무지 조회 (PartTimerApi에서 이동)
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
