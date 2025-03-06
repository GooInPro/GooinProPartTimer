import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';
import 'package:gooinpro_parttimer/models/salary/salary_model.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/services/api/salaryapi/salary_api.dart';
import 'package:intl/intl.dart';

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
  final SalaryApi _salaryApi = SalaryApi();
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'ko_KR');

  @override
  void initState() {
    super.initState();
    _loadSalaryInfo();
  }

  Future<void> _loadSalaryInfo() async {
    try {
      // 하드코딩된 pno 값 사용
      const int pno = 1;

      print('급여 정보 로드 시작 - pno: $pno, jpname: ${widget.jobMatching.jpname}');

      final salaryJobs = await _salaryApi.getSalaryByJobs(pno);
      print('API에서 가져온 급여 정보 수: ${salaryJobs.length}');

      // 현재 근무지와 일치하는 급여 정보 찾기
      SalaryJob? matchingSalary;
      for (var job in salaryJobs) {
        print('비교: [${job.jpname}] vs [${widget.jobMatching.jpname}]');
        // 공백을 제거하고 대소문자 구분 없이 비교
        if (job.jpname.trim().toLowerCase() == widget.jobMatching.jpname.trim().toLowerCase()) {
          print('급여 정보 일치 발견!');
          matchingSalary = job;
          break;
        }
      }

      if (matchingSalary == null) {
        print('일치하는 급여 정보를 찾지 못했습니다.');
      } else {
        print('일치하는 급여 정보: ${matchingSalary.jpname}, ${matchingSalary.totalHours}시간, ${matchingSalary.totalSalary}원');
      }

      setState(() {
        salaryInfo = matchingSalary;
        isLoading = false;
      });
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
                    _buildInfoRow('시급', '${_currencyFormat.format(widget.jobMatching.jmhourlyRate)}원'),
                    _buildInfoRow('계약 시작일', widget.jobMatching.jmstartDate.toString().split(' ')[0]),
                    if (widget.jobMatching.jmendDate != null)
                      _buildInfoRow('계약 종료일', widget.jobMatching.jmendDate.toString().split(' ')[0]),
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
                          _buildInfoRow('총 급여', '${_currencyFormat.format(salaryInfo!.totalSalary)}원'),
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
