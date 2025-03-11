import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/services/api/loginapi/login_api.dart';
import 'package:gooinpro_parttimer/utils/file_upload_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/login/login_register_model.dart';
import '../../models/login/login_response_model.dart';
import '../../providers/user_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late LoginRegister registerData;
  late TextEditingController _birthController;
  List<File> _imagesProfile = [];
  List<File> _imagesDocument = [];
  final picker = ImagePicker();
  final String baseUrl = dotenv.env['API_UPLOAD_LOCAL_HOST'] ?? 'No API host found';

  @override
  void initState() {
    super.initState();
    _birthController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userProvider = context.read<UserProvider>();

    registerData = LoginRegister(
      pemail: userProvider.pemail ?? '',
      pname: userProvider.pname ?? '',
      pbirth: DateTime.now(),
      pgender: true,
      proadAddress: '',
      pdetailAddress: '',
    );

    _birthController.text = formatDate(registerData.pbirth);
  }

  @override
  void dispose() {
    _birthController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await picker.pickMultiImage();
    if (pickedFile != null) {
      setState(() {
        _imagesProfile = pickedFile.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _pickDocumentImage() async {
    final pickedFile = await picker.pickMultiImage();
    if (pickedFile != null) {
      setState(() {
        _imagesDocument = pickedFile.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }


  Future<void> uploadFiles(BuildContext context, List<File> profileImages, List<File> documentImages) async {
    if (_imagesProfile == null){
      return;
    }
    // FileUploadUtil.uploadFile(context: context, images: _imagesProfile!, uri: '$baseUrl/upload/api/partTimer/document'); 안드로이드 용
    // FileUploadUtil.uploadFile(context: context, images: _imagesDocument!, uri: '$baseUrl/upload/api/partTimer/profile'); 안드로이드 용
    FileUploadUtil.uploadFile(context: context, images: _imagesProfile!, uri: 'http://localhost:8085/upload/api/partTimer/document');
    FileUploadUtil.uploadFile(context: context, images: _imagesDocument!, uri: 'http://localhost:8085/upload/api/partTimer/profile');
  }

  void _onClickSend() async {
    final loginProvider = Provider.of<UserProvider>(context, listen: false);

    login_api api = login_api();
    print("이메일: ${registerData.pemail}");
    LoginResponse response = await api.registerUser(registerData);
    print(response.accessToken);
    loginProvider.updateUserData(response.pno, response.pemail, response.pname, response.accessToken, response.refreshToken);
    uploadFiles(context, _imagesProfile, _imagesDocument);
    context.go('/jobposting');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserProvider>(
          builder: (context, userNotifier, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이메일
                Row(
                  children: [
                    Text('이메일: ', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userNotifier.pemail ?? '',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis, // 텍스트 넘칠 때 처리
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 이름
                Row(
                  children: [
                    Text('이름: ', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userNotifier.pname ?? '',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 생년월일
                Row(
                  children: [
                    Text('생년월일: ', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _birthController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: registerData.pbirth,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              registerData.pbirth = pickedDate;
                              _birthController.text = formatDate(pickedDate);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 성별 선택
                Row(
                  children: [
                    Text('성별: ', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    DropdownButton<bool>(
                      value: registerData.pgender,
                      onChanged: (value) {
                        setState(() {
                          registerData.pgender = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(value: true, child: Text('남')),
                        DropdownMenuItem(value: false, child: Text('여')),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 주소입력
                Row(
                  children: [
                    Text('주소입력: ', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '주소를 입력하세요',
                        ),
                        onChanged: (value) {
                          setState(() {
                            registerData.proadAddress = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 증명사진
                Row(
                  children: [
                    Text('증명사진', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    _imagesProfile.isEmpty
                        ? Text('no image')
                        : Container(
                      width: 60, // 고정된 크기로 설정
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imagesProfile[0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                        onPressed: _pickProfileImage,
                        child: Text('사진 선택')),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 16),

                // 증명사진
                Row(
                  children: [
                    Text('보건증', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    _imagesDocument.isEmpty
                        ? Text('no image')
                        : Container(
                      width: 60, // 고정된 크기로 설정
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imagesDocument[0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                        onPressed: _pickDocumentImage,
                        child: Text('사진 선택')),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 16),

                // 확인 버튼
                Center(
                  child: ElevatedButton(
                    onPressed: _onClickSend,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: Text('확인', style: TextStyle(fontSize: 18)),

                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}