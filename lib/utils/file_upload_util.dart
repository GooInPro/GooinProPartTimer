import 'dart:convert'; // ✅ JSON 디코딩을 위해 추가
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
      request.files.add(imageFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      print('File upload Successful: ${responseData.body}');

      try {
        // ✅ JSON 배열 형태로 디코딩
        List<String> fileNames = List<String>.from(jsonDecode(responseData.body));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful: ${fileNames.join(", ")}')),
        );

        return fileNames;
      } catch (e) {
        print('JSON 파싱 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('JSON Parsing Error')),
        );
        return [];
      }
    } else {
      print('File upload failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed')),
      );
      return [];
    }
  }
}