import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/images/parttimer_document_image_model.dart';

class parttimerDocumentImageApi {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<void> addPartTimerDocumentImage(parttimerDocumentImage imageData) async {

    final url = Uri.parse('$baseUrl/documentimage/add');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
      body: jsonEncode(imageData.toJson()), // 모델을 JSON으로 변환하여 body에 넣기
    );

    print(response.body);

  }

}