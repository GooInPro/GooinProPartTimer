import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../models/salary/salary_model.dart';

class SalaryApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  // 월별 급여 조회
  Future<List<SalaryMonthly>> getMonthlySalary(int pno, {int? year}) async {
    try {
      print('API 호스트 URL: $baseUrl'); // baseUrl 확인

      final queryParams = {
        'pno': pno.toString(),
        if (year != null) 'year': year.toString(),
      };

      final uri = Uri.parse('$baseUrl/salary/month')
          .replace(queryParameters: queryParams);
      print('요청 URL: $uri'); // 요청 URL 확인

      final response = await http.get(uri);
      print('응답 상태 코드: ${response.statusCode}'); // 응답 상태 코드 확인

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        print('응답 데이터: $decodedResponse'); // 전체 응답 데이터 확인

        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        print('Monthly Salary Response: $jsonResponse');

        final result = jsonResponse.map((json) => SalaryMonthly.fromJson(json)).toList();
        print('파싱된 월별 급여 정보 수: ${result.length}'); // 파싱된 데이터 수 확인

        return result;
      } else {
        print('API 호출 실패: ${response.statusCode}, 응답 본문: ${response.body}'); // 실패 시 응답 본문도 확인
        throw Exception('Failed to load monthly salary: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching monthly salary: $e');
      throw Exception('Error fetching monthly salary: $e');
    }
  }

  // 알바별 급여 조회
  Future<List<SalaryJob>> getSalaryByJobs(int pno) async {
    try {
      print('API 호스트 URL: $baseUrl'); // baseUrl 확인
      final requestUrl = '$baseUrl/salary/jobs?pno=$pno';
      print('요청 URL: $requestUrl'); // 요청 URL 확인

      final response = await http.get(Uri.parse(requestUrl));
      print('응답 상태 코드: ${response.statusCode}'); // 응답 상태 코드 확인

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        print('응답 데이터: $decodedResponse'); // 전체 응답 데이터 확인

        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        print('Salary by Jobs Response: $jsonResponse');

        final result = jsonResponse.map((json) => SalaryJob.fromJson(json)).toList();
        print('파싱된 급여 정보 수: ${result.length}'); // 파싱된 데이터 수 확인

        // 각 급여 정보 로그 출력
        for (var job in result) {
          print('급여 정보: jpname=${job.jpname}, totalHours=${job.totalHours}, totalSalary=${job.totalSalary}');
        }

        return result;
      } else {
        print('API 호출 실패: ${response.statusCode}, 응답 본문: ${response.body}'); // 실패 시 응답 본문도 확인
        throw Exception('Failed to load salary by jobs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching salary by jobs: $e');
      throw Exception('Error fetching salary by jobs: $e');
    }
  }

  // 일별 급여 조회
  Future<List<SalaryDaily>> getDailySalary(int pno, {int? jmno, int? year, int? month}) async {
    try {
      final queryParams = {
        'pno': pno.toString(),
        if (jmno != null) 'jmno': jmno.toString(),
        if (year != null) 'year': year.toString(),
        if (month != null) 'month': month.toString(),
      };

      final uri = Uri.parse('$baseUrl/salary/daily')
          .replace(queryParameters: queryParams);
      print('요청 URL: $uri'); // 디버깅용 로그

      final response = await http.get(uri);
      print('응답 상태 코드: ${response.statusCode}'); // 디버깅용 로그

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        print('응답 데이터: $decodedResponse'); // 디버깅용 로그

        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        return jsonResponse.map((json) => SalaryDaily.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load daily salary: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching daily salary: $e');
      throw Exception('Error fetching daily salary: $e');
    }
  }



}
