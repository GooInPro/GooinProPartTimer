import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/jobpostings/jobpostings_image_model.dart';
import '../../models/jobpostings/jobpostings_model.dart';
import '../../services/api/jobpostingsapi/jobpostings_api.dart';

class JobPostingDetailPage extends StatefulWidget {
  final int jpno;

  JobPostingDetailPage({Key? key, required this.jpno}) : super(key: key);

  @override
  _JobPostingDetailState createState() => _JobPostingDetailState();
}

class _JobPostingDetailState extends State<JobPostingDetailPage> {
  bool _isLoading = true;
  List<JobPostingDetail> jobDetailList = [];
  List<String> workingDays = [];
  List<jobPostingsImage> imageList = [];
  jobpostings_api jopostingsapi = jobpostings_api();


  @override
  void initState() {
    super.initState();
    _fetchJobPostingDetail();
  }

  Future<void> _fetchJobPostingDetail() async {
    List<JobPostingDetail> jobDetails = await jopostingsapi.getJobPostingsDetail(widget.jpno);
    List<jobPostingsImage> image = await jopostingsapi.getJobPostingsImage(widget.jpno);

    if (mounted) {
      setState(() {
        jobDetailList = jobDetails;
        imageList = image;
        _isLoading = false;
        // 데이터가 없으면 리스트 초기화
        workingDays = jobDetails.isNotEmpty ? JobPostingDetail.workDays(jobDetails[0].jpworkDays ?? "") : [];
        print("mounted------------------");
        print(imageList.isNotEmpty ? imageList[0].jpifilename[0] : '등록된 이미지 없음');
      });
    }
  }

  void _onApplyButtonPressed() {
    context.go('/jobposting/application/register', extra: widget.jpno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공고 상세"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
          IconButton(icon: Icon(Icons.flag), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // 배너 이미지
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: imageList.isNotEmpty && imageList[0].jpifilename.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage('http://localhost/jobPosting/${imageList[0].jpifilename[0]}'),
                      fit: BoxFit.cover,
                    )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageList.isEmpty || imageList[0].jpifilename.isEmpty
                      ? Center(
                    child: Text(
                      '등록된 사진이 없습니다',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                      : null,
                ),
                SizedBox(height: 16),

                // 공고 제목
                Text(
                  jobDetailList[0].jpname ?? "제목 없음",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // 위치 정보
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "${jobDetailList[0].wroadAddress ?? '위치 정보 없음'} ${jobDetailList[0].wdetailAddress ?? ''}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24, thickness: 1),

                // 급여 정보
                _buildInfoRow(Icons.attach_money, "시급: ${jobDetailList[0].jphourlyRate}원"),
                _buildInfoRow(Icons.calendar_today, "근무요일: ${workingDays.isEmpty ? '정보 없음' : workingDays.join(', ')}"),
                _buildInfoRow(Icons.date_range, "마감일: ${jobDetailList[0].jpenddate ?? '정보 없음'}"),
                _buildInfoRow(Icons.access_time, "근무 시작: ${jobDetailList[0].jpworkStartTime.format(context)}"),
                _buildInfoRow(Icons.access_time, "근무 종료: ${jobDetailList[0].jpworkEndTime.format(context)}"),
              ],
            ),
          ),

          // 지원 버튼 (화면 아래 고정)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onApplyButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // 내부 패딩 증가
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 56), // 최소 크기 설정 (가로: 꽉 채움, 세로: 56)
              ),
              child: Text(
                '지원서 작성하기',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}