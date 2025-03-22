import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gooinpro_parttimer/models/login/login_model.dart';

import '../../../models/login/login_register_model.dart';
import '../../../models/login/login_response_model.dart';

class login_api {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<LoginResponse> LoginDataSend(Login login) async {

    print("login api login data send --------------------------");

    final url = Uri.parse('$baseUrl/login/find');

    try {
      final response = await http.put(
        url, // 객체를 JSON으로 변환
        body: jsonEncode(login.toJson()),
      );

      if (response.statusCode == 200) {
        print("api 호출 성공");
        print(response.body);
        print("--------");

        final decodedResponse = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

        LoginResponse loginResponse = LoginResponse.fromJson(jsonResponse);
        print(loginResponse);
        print(loginResponse.pname);
        print(loginResponse.newUser);
        return loginResponse;
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('$e'); // 예외 출력
      rethrow; // 예외를 던져서 호출한 곳에서 처리하도록 할 수 있음
    }
  }

  Future<LoginResponse> registerUser(LoginRegister registerData) async {
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

        LoginResponse data = LoginResponse.fromJson(jsonResponse);

        // 응답에서 필요한 데이터를 추출하여 LoginRegister 객체로 변환
        return data; // 여기서 응답을 LoginRegister 객체로 반환

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


