import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/models/chat/chat_model.dart';
import 'package:http/http.dart' as http;

class chat_api {

  final String baseUrl = dotenv.env['CHAT_API_HOST'] ?? 'No API host found';

  Future<List<ChatRoomListModel>> getChatRoomListAPI({int page = 1, int size = 10, required String email}) async {

    try{
      final response = await http.get(Uri.parse('$baseUrl/chatroom/list/$email?page=$page&size=$size'));

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        final List<dynamic> data = jsonResponse['dtoList']; // PageResponseDTO의 content

        return data.map((item) => ChatRoomListModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load chatRoom List: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chatRoom List: $e');
    }
  }

  Future<List<CHatMessageModel>> getChatMessagesAPI({int page = 1, int size = 50, required String roomId}) async {

    try{
      final response = await http.get(Uri.parse('$baseUrl/chat/load/$roomId?page=$page&size=$size'));

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
        final List<dynamic> data = json.decode(decodedResponse);

        return data.map((item) => CHatMessageModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load chatRoom List: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chatRoom List: $e');
    }
  }

}