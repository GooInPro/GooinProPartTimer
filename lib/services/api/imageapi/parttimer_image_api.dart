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

}