import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/images/parttimer_image_model.dart';

class parttimerImageApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<void> addPartTimerImage(parttimerImage imageData) async {

    final url = Uri.parse('$baseUrl/image/add');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
      body: jsonEncode(imageData.toJson()), // 모델을 JSON으로 변환하여 body에 넣기
    );

    print(response.body);
  }


  Future<List<String>> getPartTimerImages(int pno) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/image/get/$pno'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(
            utf8.decode(response.bodyBytes));
        return List<String>.from(jsonResponse['pifilename']);
      } else {
        throw Exception('이미지 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('이미지 조회 오류: $e');
      return [];
    }
  }
}