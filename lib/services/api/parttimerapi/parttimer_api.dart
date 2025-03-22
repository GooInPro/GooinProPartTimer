import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../models/parttimer/parttimer_model.dart';
import '../../../models/jobmatchings/jobmatchings_model.dart';

class PartTimerApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'http://192.168.50.34:8080/part/api/v1';
  final String imageBaseUrl = dotenv.env['API_UPLOAD_LOCAL_HOST_NGINX'] ?? 'http://192.168.0.3';

  // 개인정보 조회 (이미지 포함)
  Future<PartTimer> getPartTimerDetail(int pno) async {
    try {
      print('API 서버 주소: $baseUrl');
      final detailUrl = '$baseUrl/part/detail?pno=$pno'; // 오타 수정 (`` 제거)
      print('상세 정보 요청 URL: $detailUrl');

      // 1. 기본 정보 조회
      final detailResponse = await http.get(Uri.parse(detailUrl));
      print('상세 정보 응답 코드: ${detailResponse.statusCode}');

      if (detailResponse.statusCode != 200) {
        throw Exception('기본 정보 조회 실패: ${detailResponse.statusCode}');
      }

      // 2. 데이터 파싱
      final decodedDetail = utf8.decode(detailResponse.bodyBytes);
      print('디코딩된 응답: $decodedDetail');
      final Map<String, dynamic> detailJson = json.decode(decodedDetail);
      PartTimer partTimer = PartTimer.fromJson(detailJson);

      // 3. 이미지 정보 별도 조회
      final List<String> images = await getPartTimerImages(pno);
      print('조회된 이미지 목록: $images');

      // 4. 데이터 병합
      return partTimer.copyWith(profileImageUrls: images);

    } catch (e) {
      print('개인정보 조회 오류: $e');
      throw Exception('개인정보 조회 실패: $e');
    }
  }

  // 프로필 이미지 조회
  Future<List<String>> getPartTimerImages(int pno) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_HOST']}/image/get/$pno'),
      );
      if (response.statusCode == 200) {
        return List<String>.from(json.decode(response.body));
      } else {
        throw Exception('이미지 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('이미지 조회 오류: $e');
      return [];
    }
  }

  // 개인정보 수정
  Future<void> editPartTimerInfo(int pno, PartTimer partTimer) async {
    try {
      final apiUrl = '$baseUrl/part/edit?pno=$pno';
      print('수정 요청 URL: $apiUrl');

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(partTimer.toJson()),
      );

      print('수정 응답 코드: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('정보 수정 오류: $e');
      throw Exception('정보 수정 실패: $e');
    }
  }

  // 현재 근무지 조회
  Future<List<JobMatchings>> getCurrentJobs(int pno) async {
    try {
      final apiUrl = '$baseUrl/log/current?pno=$pno';
      print('현재 근무지 URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));
      print('현재 근무지 응답 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => JobMatchings.fromJson(json)).toList();
      } else {
        throw Exception('현재 근무지 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('현재 근무지 조회 오류: $e');
      throw Exception('현재 근무지 조회 실패: $e');
    }
  }

  // 과거 근무지 조회
  Future<List<JobMatchings>> getPastJobs(int pno) async {
    try {
      final apiUrl = '$baseUrl/log/past?pno=$pno';
      print('과거 근무지 URL: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));
      print('과거 근무지 응답 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => JobMatchings.fromJson(json)).toList();
      } else {
        throw Exception('과거 근무지 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('과거 근무지 조회 오류: $e');
      throw Exception('과거 근무지 조회 실패: $e');
    }
  }

// 근무지 상세 조회
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
}