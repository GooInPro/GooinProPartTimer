import 'dart:convert';
import 'package:gooinpro_parttimer/models/worklogs/worklog_end_model.dart';
import 'package:gooinpro_parttimer/models/worklogs/worklog_start_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
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
      final url = Uri.parse('$baseUrl/worklog/end');

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

  Future<String> realStartTime(int pno, int jmno) async {
    try{

      print("real start time api------------------------");
      final response = await http.get(Uri.parse('$baseUrl/worklog/realStart?pno=$pno&jmno=$jmno'));

      if (response.statusCode == 200) {
        String data = response.body;

        String adjustData = data.substring(12,20);
        print(adjustData);
        DateTime dateTime = DateFormat("HH:mm").parse(adjustData).add(Duration(hours: 9));

        // 변환된 시간을 시:분 형식으로 반환
        String adjustedTime = DateFormat("HH:mm").format(dateTime);
        print("Adjusted Time (after adding 9 hours): $adjustedTime");

        return adjustedTime;
      } else{
        throw Exception('Failed to load workplace list: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception(e);
    }
  }
}