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
import '../../models/images/parttimer_document_image_model.dart';
import '../../models/images/parttimer_image_model.dart';
import '../../models/login/login_register_model.dart';
import '../../models/login/login_response_model.dart';
import '../../providers/user_provider.dart';
import '../../services/api/imageapi/parttimer_document_image_api.dart';
import '../../services/api/imageapi/parttimer_image_api.dart';

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
  login_api api = login_api();
  parttimerImageApi imageApi = parttimerImageApi();
  parttimerDocumentImageApi documentApi = parttimerDocumentImageApi();

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


  Future<void> uploadProFiles(BuildContext context, List<File> profileImages, int pno) async { // 증명사진 업로드


    // FileUploadUtil.uploadFile(context: context, images: _imagesProfile!, uri: '$baseUrl/upload/api/partTimer/document'); 안드로이드 용
    List<String> fileNames = await FileUploadUtil.uploadFile(context: context, images: _imagesProfile!, uri: '$baseUrl/upload/api/partTimer/profile');

    parttimerImage data = parttimerImage(pifilename: fileNames, pno: pno);

    print("---------------- upload profiles");
    print(data.pifilename);

    registerprofile(data); // 파일 정보 저장 API 호출


  }

  Future<void> uploadDcoumentFiles(BuildContext context, List<File> documentImages, int pno) async { // 보건증 및 기타 서류 업로드

    // FileUploadUtil.uploadFile(context: context, images: _imagesProfile!, uri: '$baseUrl/upload/api/partTimer/document'); 안드로이드 용
    List<String> fileNames = await FileUploadUtil.uploadFile(context: context, images: _imagesDocument!, uri: '$baseUrl/upload/api/partTimer/document');

    parttimerDocumentImage data = parttimerDocumentImage(pdifilename: fileNames, pno: pno);

    registerdocument(data);
  }

  Future<void> registerprofile(parttimerImage data) async {
    await imageApi.addPartTimerImage(data);
  }

  Future<void> registerdocument(parttimerDocumentImage data) async {
    await documentApi.addPartTimerDocumentImage(data);
  }

  void _onClickSend() async {
    final loginProvider = Provider.of<UserProvider>(context, listen: false);

    LoginResponse response = await api.registerUser(registerData);
    loginProvider.updateUserData(response.pno, response.pemail, response.pname, response.accessToken, response.refreshToken);

    uploadProFiles(context, _imagesProfile, response.pno);
    uploadDcoumentFiles(context, _imagesDocument, response.pno);


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