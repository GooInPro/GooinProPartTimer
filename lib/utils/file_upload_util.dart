import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FileUploadUtil {
  static Future<void> uploadFile({
    required BuildContext context,
    required List<File> images,
    required String uri,
}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(uri)
    );

    for (var image in images) {
      var imageFile = await http.MultipartFile.fromPath(
        'files',
        image.path,
      );
      request.files.add(imageFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var fileUrl = responseData.body;
      print('File upload Successful');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload successful: $fileUrl')),
      );
    } else {
      print('File upload failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File upload failed')),
      );
    }
  }
}