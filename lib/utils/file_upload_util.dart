import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FileUploadUtil {
  static Future<List<String>> uploadFile({
    required BuildContext context,
    required List<File> images,
    required String uri,
  }) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(uri),
    );

    for (var image in images) {
      var imageFile = await http.MultipartFile.fromPath(
        'files',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      );

      // 파일 추가
      for (var image in images) {
        print('Adding file: ${image.path}');
        var imageFile = await http.MultipartFile.fromPath(
          'files', // 백엔드에서 기대하는 필드 이름 확인 필요
          image.path,
        );
        request.files.add(imageFile);
      }

      // 요청 전송
      var response = await request.send();
      print('Upload response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        print('Upload response body: ${responseData.body}');

        try {
          // JSON 응답 파싱
          List<String> fileNames = List<String>.from(jsonDecode(responseData.body));
          print('Parsed file names: $fileNames');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload successful: ${fileNames.join(", ")}')),
          );

          return fileNames;
        } catch (e) {
          print('JSON 파싱 오류: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('JSON Parsing Error')),
          );
          return [];
        }
      } else {
        // 서버 응답 실패 처리
        print('File upload failed with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File upload failed (Status: ${response.statusCode})')),
        );
        return [];
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      print('File upload exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during file upload')),
      );
      return [];
    }
  }
}
