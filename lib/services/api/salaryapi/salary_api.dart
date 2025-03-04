import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../models/salary/salary_model.dart';

class SalaryApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  // 월별 급여 조회
  Future<List<SalaryMonthly>> getMonthlySalary(int pno, {int? year}) async {
    try {
      final queryParams = {
        'pno': pno.toString(),
        if (year != null) 'year': year.toString(),
      };

      final uri = Uri.parse('$baseUrl/part/api/v1/salary/month')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        print('Monthly Salary Response: $jsonResponse');

        return jsonResponse.map((json) => SalaryMonthly.fromJson(json)).toList();
      } else {
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
      final response = await http.get(
          Uri.parse('$baseUrl/part/api/v1/salary/jobs?pno=$pno')
      );

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        print('Salary by Jobs Response: $jsonResponse');

        return jsonResponse.map((json) => SalaryJob.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load salary by jobs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching salary by jobs: $e');
      throw Exception('Error fetching salary by jobs: $e');
    }
  }
}
