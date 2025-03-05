import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';
import 'package:gooinpro_parttimer/models/salary/salary_model.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PartTimerWorkDetailPage extends StatefulWidget {
  final JobMatchings jobMatching;

  const PartTimerWorkDetailPage({
    super.key,
    required this.jobMatching,
  });

  @override
  State<PartTimerWorkDetailPage> createState() => _PartTimerWorkDetailPageState();
}

class _PartTimerWorkDetailPageState extends State<PartTimerWorkDetailPage> {
  SalaryJob? salaryInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalaryInfo();
  }

  Future<void> _loadSalaryInfo() async {
    try {
      // 하드코딩된 pno 값 사용
      const int pno = 1;

      // API 호스트 가져오기 (.env 파일에는 기본 URL만 포함: "API_HOST=http://192.168.50.34:8080")
      final apiHost = dotenv.env['API_HOST'] ?? 'http://192.168.50.34:8080';
      print('API 호스트: $apiHost'); // 로그 추가

      final url = '$apiHost/part/api/v1/salary/jobs?pno=$pno';
      print('요청 URL: $url'); // 로그 추가

      final response = await http.get(Uri.parse(url));
      print('응답 상태 코드: ${response.statusCode}'); // 로그 추가

      if (response.statusCode == 200) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        print('응답 데이터: $decodedResponse'); // 로그 추가

        final List<dynamic> jsonResponse = json.decode(decodedResponse);
        final List<SalaryJob> salaryJobs = jsonResponse.map((json) => SalaryJob.fromJson(json)).toList();

        print('파싱된 급여 정보 수: ${salaryJobs.length}'); // 로그 추가

        // 현재 근무지와 일치하는 급여 정보 찾기
        SalaryJob? matchingSalary;
        for (var job in salaryJobs) {
          print('비교: ${job.jpname} vs ${widget.jobMatching.jpname}'); // 로그 추가
          if (job.jpname == widget.jobMatching.jpname) {
            matchingSalary = job;
            break;
          }
        }

        setState(() {
          salaryInfo = matchingSalary;
          isLoading = false;
        });
      } else {
        print('API 호출 실패: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('급여 정보 로드 중 오류 발생: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatWorkDays(String workDays) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final workingDays = [];

    for (var i = 0; i < workDays.length; i++) {
      if (workDays[i] == '1') {
        workingDays.add(days[i]);
      }
    }

    return workingDays.join(', ');
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    print('JobMatching data:');
    print('jmno: ${widget.jobMatching.jmno}');
    print('jpname: ${widget.jobMatching.jpname}');
    print('wroadAddress: ${widget.jobMatching.wroadAddress}');
    print('wdetailAddress: ${widget.jobMatching.wdetailAddress}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobMatching.jpname),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 근무지 정보 카드
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '근무 정보',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('근무 요일', _formatWorkDays(widget.jobMatching.jmworkDays)),
                    if (widget.jobMatching.jmworkStartTime != null &&
                        widget.jobMatching.jmworkEndTime != null)
                      _buildInfoRow(
                        '근무 시간',
                        '${_formatTime(widget.jobMatching.jmworkStartTime!)} ~ ${_formatTime(widget.jobMatching.jmworkEndTime!)}',
                      ),
                    _buildInfoRow('시급', '${widget.jobMatching.jmhourlyRate}원'),
                    _buildInfoRow('근무 시작일', widget.jobMatching.jmstartDate.toString().split(' ')[0]),
                    if (widget.jobMatching.jmendDate != null)
                      _buildInfoRow('근무 종료일', widget.jobMatching.jmendDate.toString().split(' ')[0]),
                    if (widget.jobMatching.wroadAddress != null)
                      _buildInfoRow('도로명 주소', widget.jobMatching.wroadAddress!),
                    if (widget.jobMatching.wdetailAddress != null)
                      _buildInfoRow('상세 주소', widget.jobMatching.wdetailAddress!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 급여 정보 카드
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '급여 정보',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (salaryInfo != null)
                      Column(
                        children: [
                          _buildInfoRow('총 근무 시간', '${salaryInfo!.totalHours}시간'),
                          _buildInfoRow('총 급여', '${salaryInfo!.totalSalary}원'),
                          _buildInfoRow('근무 기간',
                              '${salaryInfo!.startDate.toString().split(' ')[0]} ~ ${salaryInfo!.endDate.toString().split(' ')[0]}'),
                        ],
                      )
                    else
                      const Text('급여 정보가 없습니다.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 급여 이력 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/parttimer/calendar', extra:widget.jobMatching);
                },
                child: const Text('급여 이력'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
