import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final String baseUrl = dotenv.env['API_UPLOAD_LOCAL_HOST_NGINX'] ?? 'No API host found';

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
        workingDays = jobDetails.isNotEmpty ? JobPostingDetail.workDays(jobDetails[0].jpworkDays ?? "") : [];
        print("mounted------------------");
        print(imageList.isNotEmpty ? imageList[0].jpifilename[0] : '등록된 이미지 없음');
        print(baseUrl);
      });
    }
  }

  void _onApplyButtonPressed() {
    context.go('/jobposting/application/register', extra: widget.jpno);
  }

  void _onReviewButtonPressed() {
    if (jobDetailList.isEmpty) return;
    final eno = jobDetailList[0].eno;
    context.go('/review/jobpostings/$eno');
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
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: imageList.isNotEmpty && imageList[0].jpifilename.isNotEmpty
                        ? DecorationImage(

                      image: NetworkImage('${baseUrl}/jobPosting/${imageList[0].jpifilename[0]}'),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: imageList.isEmpty || imageList[0].jpifilename.isEmpty
                      ? Center(
                    child: Text(
                      '등록된 사진이 없습니다',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : null,
                ),
                SizedBox(height: 16),
                Text(
                  jobDetailList[0].jpname ?? "제목 없음",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
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
                _buildInfoRow(Icons.attach_money, "시급: ${jobDetailList[0].jphourlyRate}원"),
                _buildInfoRow(Icons.calendar_today, "근무요일: ${workingDays.isEmpty ? '정보 없음' : workingDays.join(', ')}"),
                _buildInfoRow(Icons.date_range, "마감일: ${jobDetailList[0].jpenddate ?? '정보 없음'}"),
                _buildInfoRow(Icons.access_time, "근무 시작: ${jobDetailList[0].jpworkStartTime.format(context)}"),
                _buildInfoRow(Icons.access_time, "근무 종료: ${jobDetailList[0].jpworkEndTime.format(context)}"),
              ],
            ),
          ),
          // 리뷰 보기 버튼
          Padding(
            padding: EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
            child: ElevatedButton(
              onPressed: _onReviewButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 56),
              ),
              child: Text(
                '리뷰 보기',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 지원 버튼
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onApplyButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 56),
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
