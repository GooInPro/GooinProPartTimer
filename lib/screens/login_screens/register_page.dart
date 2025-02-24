import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/services/api/loginapi/login_api.dart';
import 'package:intl/intl.dart';
import '../../models/login/login_register_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 모델 초기화
  LoginRegister registerData = LoginRegister(
    pemail: 'duqdjs123@naver.com',
    pname: '이동언',
    pbirth: DateTime.now(), // 기본값: 현재 날짜
    pgender: true, // 성별 기본값
    proadAddress: '',
    pdetailAddress: '',
  );

  late TextEditingController _birthController;

  @override
  void initState() {
    super.initState();
    _birthController = TextEditingController(text: formatDate(registerData.pbirth));
  }

  @override
  void dispose() {
    _birthController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _onClickSend() async {
    // 버튼 클릭 시 실행할 로직을 추가할 수 있습니다.
    login_api api = login_api();

    await api.registerUser(registerData);
    // 예: 구직 신청 API 호출 등
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이메일
            Row(
              children: [
                Text('이메일: ', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    registerData.pemail,
                    style: TextStyle(fontSize: 18),
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
                    registerData.pname,
                    style: TextStyle(fontSize: 18),
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
                    readOnly: true, // 직접 입력 방지
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

            // 확인 버튼
            ElevatedButton(
              onPressed: () {
                _onClickSend();
                print('입력된 데이터:');
                print('이메일: ${registerData.pemail}');
                print('이름: ${registerData.pname}');
                print('생일: ${formatDate(registerData.pbirth)}'); // ✅ 날짜 포맷 적용
                print('성별: ${registerData.pgender ? '남' : '여'}');
                print('주소: ${registerData.proadAddress}');
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}