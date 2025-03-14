import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../models/review/review_model.dart';

class ReviewApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  // 리뷰 작성
  Future<void> createReview(Review review) async {
    try {
      final response = await http.put(
          Uri.parse('$baseUrl/employee/review/create'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(review.toJson())
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create review: ${response.statusCode}');
      }
      print('Successfully created review');
    } catch (e) {
      print('Error creating review: $e');
      throw Exception('Error creating review: $e');
    }
  }

  // 리뷰 목록 조회 (키워드, 고용주 ID, 파트타이머 ID로 필터링)
  Future<List<Review>> getReviewList({String? keyword, int? eno, int? pno}) async {
    try {
      // 쿼리 파라미터 로깅
      print('리뷰 목록 조회 파라미터: keyword=$keyword, eno=$eno, pno=$pno');

      // 쿼리 파라미터 구성
      final queryParams = <String, String>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (eno != null) queryParams['eno'] = eno.toString();
      if (pno != null) queryParams['pno'] = pno.toString();

      final uri = Uri.parse('$baseUrl/employee/review/list')
          .replace(queryParameters: queryParams);

      print('리뷰 목록 조회 URL: $uri');
      final response = await http.get(uri);
      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        print('디코딩된 응답: $decodedResponse');

        // JSON 파싱 전 로그
        try {
          final List<dynamic> jsonResponse = json.decode(decodedResponse);
          print('파싱된 JSON: $jsonResponse');

          // 각 항목 디버깅
          final reviews = jsonResponse.map((json) {
            print('리뷰 항목: $json');
            return Review.fromJson(json);
          }).toList();

          return reviews;
        } catch (e) {
          print('JSON 파싱 오류: $e');
          throw Exception('Error parsing review data: $e');
        }
      } else {
        throw Exception('Failed to load review list: ${response.statusCode}');
      }
    } catch (e) {
      print('리뷰 목록 조회 오류: $e');
      throw Exception('Error fetching review list: $e');
    }
  }
}
