import 'package:gooinpro_parttimer/models/jobpostings/jobpostings_image_model.dart';
import 'package:gooinpro_parttimer/models/page/pageresponse_model.dart';
import 'package:gooinpro_parttimer/models/worklogs/worklog_start_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../../../models/jobpostings/jobpostings_model.dart';
import '../../../models/jobpostings_application/jobpostings_application_model.dart';


class jobpostings_api {
  final String baseUrl = dotenv.env['API_HOST'] ?? 'No API host found';

  Future<PageResponseDTO> getJobPostingsList(int page) async {
    print(baseUrl);
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobposting/list?page=$page'));

      // 서버 응답이 UTF-8로 잘 디코딩되어 있지 않으면 수동으로 디코딩
      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        print("----");
        print(jsonResponse);
        final List<dynamic> data = jsonResponse['dtoList']; // PageResponseDTO의 content
        print("-----2");
        final int totalPage = jsonResponse['totalPage'];
        final bool prev = jsonResponse['prev'];
        final bool next = jsonResponse['next'];

        print(PageResponseDTO.fromJson(jsonResponse));

        return PageResponseDTO.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load workplace list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching workplace list: $e');
    }
  }

  Future<List<JobPostingDetail>> getJobPostingsDetail(int jpno) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobposting/detail/$jpno'));
      print('API 응답 상태 코드: ${response.statusCode}');
      print('API 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        print('디코딩된 응답: $decodedResponse');
        final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);
        print('파싱된 JSON: $jsonResponse');

        final JobPostingDetail jobDetail = JobPostingDetail.fromJson(jsonResponse);
        return [jobDetail];
      } else {
        print('API 오류: ${response.statusCode}');
        throw Exception('Failed to load job posting detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching job posting detail: $e');
      throw e; // 오류를 던져서 호출자가 처리하도록 함
    }
  }

  Future<void> addApplicationPostings(JobPostingsApplication application) async {

    final url = Uri.parse('$baseUrl/jobpostingapplication/add');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // JSON 헤더 추가
      body: jsonEncode(application.toJson()), // 모델을 JSON으로 변환하여 body에 넣기
    );

  }

  Future<List<jobPostingsImage>> getJobPostingsImage(int jpno) async {

    try{

      final response = await http.get(Uri.parse('$baseUrl/jobPostingsImage/get?jpno=$jpno'));
      final String decodedResponse = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = json.decode(decodedResponse);

      print(jsonResponse);
      print('------------------- jobpostings api');

      List<String> filenames = List<String>.from(jsonResponse['jpifilename']);
      print(filenames);

      List<jobPostingsImage> dataList = filenames.map((filename) => jobPostingsImage(jpifilename: filenames)).toList();

      print(dataList);

      return dataList;


    } catch (e) {
      throw Exception(e);
    }


  }


}