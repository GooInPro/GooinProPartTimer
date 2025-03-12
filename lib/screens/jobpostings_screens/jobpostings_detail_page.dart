import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/jobpostings/jobpostings_model.dart';
import '../../services/api/jobpostingsapi/jobpostings_api.dart';


class JobPostingDetailPage extends StatefulWidget {
  final int jpno;

  JobPostingDetailPage({Key? key, required this.jpno}) : super(key: key);

  @override
  _JobPostingDetailState createState() => _JobPostingDetailState();
}

class _JobPostingDetailState extends State<JobPostingDetailPage> {
  bool _isLoading = true; // 로딩 상태
  List<JobPostingDetail> jobDetailList = [];
  List<String> workingDays = []; // 요일

  @override
  void initState() {
    super.initState();
    _fetchJobPostingDetail(); // 직업 공고 가져오기
  }

  Future<void> _fetchJobPostingDetail() async {
    try {
      List<JobPostingDetail> jobDetails = await jobpostings_api().getJobPostingsDetail(widget.jpno);
      if (mounted) {
        setState(() {
          jobDetailList = jobDetails;
          _isLoading = false;

          if (jobDetails.isNotEmpty) {
            print("--------------job detail");
            workingDays = JobPostingDetail.workDays(jobDetails[0].jpworkDays ?? "");
          } else {
            workingDays = [];
            print("빈 리스트 반환됨");
          }
        });
      }
    } catch (e) {
      print('Error fetching job details: $e');
      if (mounted) {
        setState(() {
          jobDetailList = [];
          workingDays = [];
          _isLoading = false;
        });
      }
    }
  }

  void _onApplyButtonPressed() {
    // 버튼 클릭 시 실행할 로직을 추가할 수 있습니다.
    context.go('/jobposting/application/register', extra: widget.jpno);
    // 예: 구직 신청 API 호출 등
  }


  @override
  Widget build(BuildContext context) {
    // 간단한 화면 표시 (라우터 테스트용)
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때
          : Center(
        child: ListView(
          children: [
            Text(
              '공고명: ${jobDetailList[0].jpname}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            Text(
              '주소: ${jobDetailList[0].wroadAddress ?? '정보 없음'} ${jobDetailList[0].wdetailAddress ?? '정보 없음'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),

            // 시급
            Text(
              '시급: ${jobDetailList[0].jphourlyRate}원',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),

            // 근무요일
            Text(
              '근무요일: ${workingDays.isEmpty ? '정보 없음' : workingDays.join(', ')}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),

            // 마감일
            Text(
              '마감일: ${jobDetailList[0].jpenddate ?? '정보 없음'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),

            // 근무시작시간
            Text(
              '근무 시작 시간: ${jobDetailList[0].jpworkStartTime.format(context)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),

            // 근무 종료시간
            Text(
              '근무 종료 시간: ${jobDetailList[0].jpworkEndTime.format(context)}',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: _onApplyButtonPressed,
              child: Text('지원서 작성하기'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blue, // 버튼 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 둥근 모서리
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (jobDetailList.isNotEmpty) {
                  context.go('/review/jobpostings/${jobDetailList[0].eno}');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('공고 정보를 불러올 수 없습니다.')),
                  );
                }
              },
              child: const Text('공고업체 리뷰 보기'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}