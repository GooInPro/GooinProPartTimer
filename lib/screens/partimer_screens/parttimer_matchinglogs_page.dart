import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';
import 'package:gooinpro_parttimer/services/api/parttimerapi/parttimer_api.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class PartTimerMatchingLogsPage extends StatefulWidget {
  const PartTimerMatchingLogsPage({super.key});

  @override
  State<PartTimerMatchingLogsPage> createState() => _PartTimerMatchingLogsPageState();
}

class _PartTimerMatchingLogsPageState extends State<PartTimerMatchingLogsPage> {
  final PartTimerApi _partTimerApi = PartTimerApi();
  List<JobMatchings>? _currentJobs;
  List<JobMatchings>? _pastJobs;
  bool _isLoading = true;

  late UserProvider userProvider; // provider 1

  @override
  void initState() {
    super.initState();
  }

  @override // provider 2
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();

    _loadJobMatchings();
  }

  Future<void> _loadJobMatchings() async {
    try {
      final currentJobs = await _partTimerApi.getCurrentJobs(userProvider.pno!);
      final pastJobs = await _partTimerApi.getPastJobs(userProvider.pno!);

      setState(() {
        _currentJobs = currentJobs;
        _pastJobs = pastJobs;
        _isLoading = false;
      });
    } catch (e) {
      print('근무지 목록 로드 중 오류 발생: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('근무 이력'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '현재 근무지'),
              Tab(text: '과거 근무지'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildJobList(_currentJobs, true),
            _buildJobList(_pastJobs, false),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList(List<JobMatchings>? jobs, bool isCurrent) {
    if (jobs == null) {
      return const Center(child: Text('근무지 정보를 불러올 수 없습니다.'));
    }

    if (jobs.isEmpty) {
      return Center(
        child: Text(isCurrent ? '현재 근무중인 곳이 없습니다.' : '과거 근무 이력이 없습니다.'),
      );
    }

    return ListView.builder(
      itemCount: jobs.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              context.go('/parttimer/workdetail', extra: job);
              print('Navigating to detail with data: ${job.toString()}');
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.jpname,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('시급: ${job.jmhourlyRate}원'),
                  Text('근무 시작일: ${job.jmstartDate.toString().split(' ')[0]}'),
                  if (job.jmendDate != null)
                    Text('근무 종료일: ${job.jmendDate.toString().split(' ')[0]}'),
                  Text('근무 요일: ${_formatWorkDays(job.jmworkDays)}'),
                  if (job.jmworkStartTime != null && job.jmworkEndTime != null)
                    Text('근무 시간: ${_formatTime(job.jmworkStartTime!)} ~ ${_formatTime(job.jmworkEndTime!)}'),
                ],
              ),
            ),
          ),
        );
      },
    );
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
}