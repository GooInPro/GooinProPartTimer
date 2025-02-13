// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';
// import '../../../models/parttimer/parttimer_model.dart';
//
// class PartTimerApi {
//   final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';
//
//   // 개인정보 조회
//   Future<PartTimer> getPartTimerDetail(int pno) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/part/detail?pno=$pno'),
//       );
//
//       if (response.statusCode == 200) {
//         final decodedResponse = utf8.decode(response.bodyBytes);
//         final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
//         return PartTimer.fromJson(jsonResponse);
//       } else {
//         throw Exception('Failed to load parttimer info: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching parttimer info: $e');
//     }
//   }
//
//   // 개인정보 수정
//   Future<void> editPartTimerInfo(int pno, PartTimer partTimer) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/part/edit?pno=$pno'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(partTimer.toJson()),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to update parttimer info: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating parttimer info: $e');
//     }
//   }
//
//   // 계정 삭제
//   Future<void> deactivateAccount(int pno) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/part/account/deactivate?pno=$pno'),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to deactivate account: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error deactivating account: $e');
//     }
//   }
// }
