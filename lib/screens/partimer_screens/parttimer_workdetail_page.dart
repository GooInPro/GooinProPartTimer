import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';
import 'package:go_router/go_router.dart';

class PartTimerWorkDetailPage extends StatefulWidget {
  final JobMatchings jobMatching;  // 근무지 정보를 받아올 매개변수

  const PartTimerWorkDetailPage({
    super.key,
    required this.jobMatching,
  });

  @override
  State<PartTimerWorkDetailPage> createState() => _PartTimerWorkDetailPageState();
}

class _PartTimerWorkDetailPageState extends State<PartTimerWorkDetailPage> {
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