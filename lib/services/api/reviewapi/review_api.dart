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
          Uri.parse('$baseUrl/part/api/v1/employee/review/create'),
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

  // 리뷰 목록 조회
  Future<List<Review>> getReviewList({String? keyword}) async {
    try {
      final queryParams = keyword != null ? {'keyword': keyword} : null;
      final uri = Uri.parse('$baseUrl/part/api/v1/employee/review/list')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        print('Review List Response: $jsonResponse');

        return jsonResponse.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load review list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching review list: $e');
      throw Exception('Error fetching review list: $e');
    }
  }
}