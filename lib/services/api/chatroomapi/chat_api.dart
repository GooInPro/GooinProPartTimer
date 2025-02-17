import 'package:flutter_dotenv/flutter_dotenv.dart';

class chat_api {

  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';



}