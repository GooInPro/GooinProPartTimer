import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/models/parttimer/parttimer_model.dart';
import 'package:gooinpro_parttimer/services/api/parttimerapi/parttimer_api.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_header.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_section.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_edit.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class PartTimerMyInfoPage extends StatefulWidget {
  const PartTimerMyInfoPage({super.key});

  @override
  State<PartTimerMyInfoPage> createState() => _PartTimerMyInfoPageState();
}

class _PartTimerMyInfoPageState extends State<PartTimerMyInfoPage> {
  final PartTimerApi _partTimerApi = PartTimerApi();
  PartTimer? _partTimer;
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
    _loadPartTimerInfo();
  }

  Future<void> _loadPartTimerInfo() async {
    try {
      final partTimer = await _partTimerApi.getPartTimerDetail(userProvider.pno!);
      setState(() {
        _partTimer = partTimer;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading parttimer info: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showEditDialog(BuildContext context) async {
    if (_partTimer == null) return;

    showDialog(
      context: context,
      builder: (context) =>
          PartTimerMyInfoEdit(
            partTimer: _partTimer!,
            onSave: (updatedPartTimer) async {
              try {
                await _partTimerApi.editPartTimerInfo(
                    userProvider.pno!, updatedPartTimer);
                // 수정 성공 후 정보 다시 로드
                await _loadPartTimerInfo();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('정보가 수정되었습니다.')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('정보 수정에 실패했습니다.')),
                  );
                }
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_partTimer == null) {
      return const Center(child: Text('정보를 불러올 수 없습니다.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          PartTimerMyInfoHeader(
            name: _partTimer!.pname,
            email: _partTimer!.pemail,
          ),
          PartTimerMyInfoSection(
            title: '생년월일',
            content: _partTimer!.pbirth.toString().split(' ')[0],
          ),
          PartTimerMyInfoSection(
            title: '성별',
            content: _partTimer!.pgender ? '남성' : '여성',
          ),
          PartTimerMyInfoSection(
            title: '도로명주소',
            content: _partTimer!.proadAddress,
          ),
          if (_partTimer!.pdetailAddress.isNotEmpty)
            PartTimerMyInfoSection(
              title: '상세주소',
              content: _partTimer!.pdetailAddress,
            ),
          const SizedBox(height: 20), // 간격 추가
          ElevatedButton(
            onPressed: () {
              context.go('/parttimer/matchinglogs'); // 근무이력 페이지로 이동
            },
            child: const Text('근무 이력 보기'),
          ),
          const SizedBox(height: 10), // 버튼 사이 간격 추가
          ElevatedButton(
            onPressed: () {
              context.go('/parttimer/calendartotal'); // 전체 급여 달력 페이지로 이동
            },
            child: const Text('급여 달력 보기'),
          ),
        ],
      ),
    );
  }
}