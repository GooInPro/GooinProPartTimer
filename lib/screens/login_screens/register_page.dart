import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/services/api/loginapi/login_api.dart';
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

  void _onClickSend() async {
    login_api api = login_api();
    print("이메일: ${registerData.pemail}");
    LoginResponse response = await api.registerUser(registerData);
    print(response.accessToken);
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

                // 확인 버튼
                ElevatedButton(
                  onPressed: _onClickSend,
                  child: Text('확인'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}