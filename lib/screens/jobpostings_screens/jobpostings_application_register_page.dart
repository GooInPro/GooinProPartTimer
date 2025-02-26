import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/jobpostings_application/jobpostings_application_model.dart';
import '../../providers/user_provider.dart';
import '../../services/api/jobpostingsapi/jobpostings_api.dart';

class JobApplication {

  String jpacontent;
  String jpahourlyRate;
  int pno;
  int jpno;

  JobApplication({this.jpacontent = '', this.jpahourlyRate = '', this.pno = 1, required this.jpno});

}

class JobPostingsApplicationRegisterPage extends StatefulWidget {
  final int jpno;

  JobPostingsApplicationRegisterPage({Key? key, required this.jpno}) : super(key: key);

  @override
  _JobPostingsApplicationState createState() =>
      _JobPostingsApplicationState();
}



class _JobPostingsApplicationState extends State<JobPostingsApplicationRegisterPage> {
  late JobApplication jobApplication;
  late UserProvider userProvider; // provider 1

  @override
  void initState() {
    super.initState();
    jobApplication = JobApplication(jpno: widget.jpno); // widget.jpno를 초기화 시 전달
  }

  @override // provider 2
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
  }

  JobPostingsApplication _convertToJobPostingsApplication(JobApplication jobApplication) {
    return JobPostingsApplication(
      jpacontent: jobApplication.jpacontent,
      jpahourlyRate: jobApplication.jpahourlyRate,
      pno: userProvider.pno ?? 1, // provider 3
      jpno: jobApplication.jpno,
    );
  }

  void _onClickSend() async {
    // 버튼 클릭 시 실행할 로직을 추가할 수 있습니다.
    JobPostingsApplication application = _convertToJobPostingsApplication(jobApplication);

    jobpostings_api api = jobpostings_api();

    await api.addApplicationPostings(application);

    print(application.toString());

    context.go("/jobposting");
    // 예: 구직 신청 API 호출 등
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지원서 등록'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 메모: 좌측에 텍스트, 우측에 TextField
              Row(
                children: [
                  Text(
                    '메모: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          jobApplication.jpacontent = text; // 메모 값 업데이트
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '사장님에게 원하는 메시지를 남겨주세요',
                      ),
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 희망 시급: 좌측에 텍스트, 우측에 TextField
              Row(
                children: [
                  Text(
                    '희망 시급: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          jobApplication.jpahourlyRate = text; // 희망 시급 값 업데이트
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '희망 시급을 입력하세요',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onClickSend,
                    child: Text('신청하기'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                      backgroundColor: Colors.blue, // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 둥근 모서리
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}