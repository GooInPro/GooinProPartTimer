import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/models/login/login_model.dart';

import '../../../models/login/login_register_model.dart';

class login_api {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<bool> LoginDataSend(Login login) async {
    final String email = login.pemail;

    final url = Uri.parse('$baseUrl/login/find/$email');

    try {
      final response = await http.get(
        url, // 객체를 JSON으로 변환
      );

      if (response.statusCode == 200) {
        print("api 호출 성공");
        Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>; // isNew값만 들고오면되니까 굳이 model안씀
        bool isNew = jsonResponse["new"];
        return isNew;
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('$e'); // 예외 출력
      rethrow; // 예외를 던져서 호출한 곳에서 처리하도록 할 수 있음
    }
  }

  Future<LoginRegister> registerUser(LoginRegister registerData) async {
    final url = Uri.parse('$baseUrl/login/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
        body: jsonEncode(registerData.toJson()),
      );

      if (response.statusCode == 200) {
        print("회원가입 API 호출 성공");

        // 서버에서 반환한 응답 데이터 처리
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // 응답에서 필요한 데이터를 추출하여 LoginRegister 객체로 변환
        return LoginRegister.fromJson(jsonResponse); // 여기서 응답을 LoginRegister 객체로 반환

      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        throw Exception('회원가입 실패');
      }
    } catch (e) {
      print(e);
      rethrow; // 예외를 던져서 호출한 곳에서 처리하도록 할 수 있음
    }
  }
}


