import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/jobmatchings/work_list_model.dart';
import '../../../models/jobmatchings/work_tims_model.dart';

class InOutapi{
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<List<WorkList>> getWorkList(int pno) async {
    try{
      print("-------------");
      print(baseUrl);
      final response = await http.get(Uri.parse('$baseUrl/log/workList?pno=$pno'));


      if(response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        print("---------------------");
        print(jsonResponse);
        List<dynamic> workListData = jsonResponse['dtoList'];
        print(workListData);
        return workListData.map((item) => WorkList.fromJson(item)).toList();
      } else{
        throw Exception(response.statusCode);
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<WorkTimes> getWorkTime(int pno, int jpno) async {
    try{
      print("work time--------------");
      final response = await http.get(Uri.parse('$baseUrl/log/time?pno=$pno&jpno=$jpno'));

      if(response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        print(jsonResponse);

        WorkTimes data = WorkTimes.fromJson(jsonResponse);
        return data;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}