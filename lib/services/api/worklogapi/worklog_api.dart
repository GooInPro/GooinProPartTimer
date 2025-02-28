import 'dart:convert';
import 'package:gooinpro_parttimer/models/worklogs/worklog_end_model.dart';
import 'package:gooinpro_parttimer/models/worklogs/worklog_start_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/worklogs/worklog_send_model.dart';

class WorkLogApi {

  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';


  Future<WorkLogStart> sendStartTime(WorkLogSend sendData) async {
    try{
      print("api---------");
      print(baseUrl);
      print(sendData.toJson());

      final url = Uri.parse('$baseUrl/worklog/start');

      final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
      body: jsonEncode(sendData.toJson()), // 모델을 JSON으로 변환하여 body에 넣기
      );

      final DecodeData = jsonDecode(response.body);
      print(DecodeData);
      print("return response ----------");
      print(WorkLogStart.fromJson(DecodeData));

      return WorkLogStart.fromJson(DecodeData);

    } catch(e) {
      throw Exception(e);
    }

  }

  Future<WorkLogEnd> sendEndTime(WorkLogSend sendData) async {
    try{
      final url = Uri.parse('${baseUrl}/worklog/end');

      print(url);
      print(sendData.toJson());

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
        body: jsonEncode(sendData.toJson()), // 모델을 JSON으로 변환하여 body에 넣기
      );

      final DecodeData = jsonDecode(response.body);

      print(WorkLogEnd.fromJson(DecodeData));

      return WorkLogEnd.fromJson(DecodeData);
    } catch (e){
     throw Exception (e);
    }
  }
}