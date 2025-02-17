import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/jobpostings_application/jobpostings_application_model.dart';
import '../../services/api/jobpostingsapi/jobpostings_api.dart';

class JobApplication {
  String jpacontent;
  String jpahourlyRate;
  int pno = 1;
  int jpno;

  JobApplication({this.jpacontent = '', this.jpahourlyRate = '', this.pno = 1, required this.jpno});

  @override
  String toString() {
    return 'JobApplication(jpacontent: $jpacontent, jpahourlyRate: $jpahourlyRate, pno: $pno, jpno: $jpno)';
  }
}

class JobPostingsApplicationRegisterPage extends StatefulWidget {
  final int jpno;

  JobPostingsApplicationRegisterPage({Key? key, required this.jpno}) : super(key: key);

  @override
  _JobPostingsApplicationState createState() =>
      _JobPostingsApplicationState();
}



class _JobPostingsApplicationState extends State<JobPostingsApplicationRegisterPage> {
  var jobApplication;

  @override
  void initState() {
    super.initState();
    jobApplication = JobApplication(jpno: widget.jpno); // widget.jpno를 초기화 시 전달
  }

  JobPostingsApplication _convertToJobPostingsApplication(JobApplication jobApplication) {
    return JobPostingsApplication(
      jpacontent: jobApplication.jpacontent,
      jpahourlyRate: jobApplication.jpahourlyRate,
      pno: jobApplication.pno,
      jpno: jobApplication.jpno,
    );
  }

  void _onClickSend() async {
    // 버튼 클릭 시 실행할 로직을 추가할 수 있습니다.
    JobPostingsApplication application = _convertToJobPostingsApplication(jobApplication);

    jobpostings_api api = jobpostings_api();

    await api.addApplicationPostings(application);

    print(application.toString());
    // 예: 구직 신청 API 호출 등
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지원서 등록${widget.jpno}'),
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