import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class workplace_api {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<List<Map<String, dynamic>>> getWorkPlaceList({int page = 1, int size = 10}) async {
    print("-------1");
    print(baseUrl);
    try {
      final response = await http.get(Uri.parse('$baseUrl/workplace/list?page=$page&size=$size'));

      // 서버 응답이 UTF-8로 잘 디코딩되어 있지 않으면 수동으로 디코딩
      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        print(jsonResponse);
        final List<dynamic> content = jsonResponse['content']; // PageResponseDTO의 content
        print(content);

        return content.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load workplace list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching workplace list: $e');
    }
  }
}