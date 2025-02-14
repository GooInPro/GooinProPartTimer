import 'package:flutter/material.dart';

import '../models/jobpostings/jobpostings_model.dart';
import '../services/api/jobpostingsapi/jobpostings_api.dart';


class JobPostingDetailPage extends StatefulWidget {
  final int jpno;

  JobPostingDetailPage({Key? key, required this.jpno}) : super(key: key);

  @override
  _JobPostingDetailState createState() => _JobPostingDetailState();
}

class _JobPostingDetailState extends State<JobPostingDetailPage> {
  bool _isLoading = true; // 로딩 상태
  List<JobPostingDetail> jobDetailList = [];

  @override
  void initState() {
    super.initState();
    _fetchJobPostingDetail(); // 직업 공고 가져오기
  }

  Future<void> _fetchJobPostingDetail() async {
    List<JobPostingDetail> jobDetails = await jobpostings_api().getJobPostingsDetail(widget.jpno);
    if (mounted) {
      setState(() {
        jobDetailList = jobDetails;
        _isLoading = false; // 로딩 완료
        print("--------------job detail");
        print(jobDetails);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 간단한 화면 표시 (라우터 테스트용)
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posting Detail'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때
          : Center(
        child: Text(
          'Job Posting No: ${widget.jpno}', // `jpno` 값을 표시
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}