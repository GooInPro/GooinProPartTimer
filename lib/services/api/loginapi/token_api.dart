import 'package:http/http.dart' as http;

Future<void> refreshRequest(String accessToken, String refreshToken) async {
  final Uri url = Uri.parse('${String.fromEnvironment('API_HOST')}/login/refresh?refreshToken=$refreshToken');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    // 성공적인 응답 처리
    print('Refresh successful');
  } else {
    // 실패 처리
    print('Failed to refresh');
  }
}
