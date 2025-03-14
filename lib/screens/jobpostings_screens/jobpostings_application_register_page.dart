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
  _JobPostingsApplicationState createState() => _JobPostingsApplicationState();
}

class _JobPostingsApplicationState extends State<JobPostingsApplicationRegisterPage> {
  late JobApplication jobApplication;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    jobApplication = JobApplication(jpno: widget.jpno);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
  }

  JobPostingsApplication _convertToJobPostingsApplication(JobApplication jobApplication) {
    return JobPostingsApplication(
      jpacontent: jobApplication.jpacontent,
      jpahourlyRate: jobApplication.jpahourlyRate,
      pno: userProvider.pno ?? 1,
      jpno: jobApplication.jpno,
    );
  }

  void _onClickSend() async {
    JobPostingsApplication application = _convertToJobPostingsApplication(jobApplication);
    jobpostings_api api = jobpostings_api();
    await api.addApplicationPostings(application);
    print(application.toString());
    context.go("/jobposting");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지원서 등록'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 메모 입력
            Text(
              '메모:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (text) {
                setState(() {
                  jobApplication.jpacontent = text;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '사장님에게 원하는 메시지를 남겨주세요',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),

            // 희망 시급 입력
            Text(
              '희망 시급:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (text) {
                setState(() {
                  jobApplication.jpahourlyRate = text;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '희망 시급을 입력하세요',
              ),
            ),
            SizedBox(height: 24),

            // 가로로 길게 배치된 버튼
            SizedBox(
              width: double.infinity, // 가로 전체 차지
              height: 50, // 버튼 높이 설정
              child: ElevatedButton(
                onPressed: _onClickSend,
                child: Text('신청하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 둥근 모서리
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}