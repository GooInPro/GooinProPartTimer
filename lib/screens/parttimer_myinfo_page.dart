import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/parttimer/parttimer_model.dart';
import 'package:gooinpro_parttimer/services/api/parttimerapi/parttimer_api.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_header.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_section.dart';

class PartTimerMyInfoPage extends StatefulWidget {
  const PartTimerMyInfoPage({super.key});

  @override
  State<PartTimerMyInfoPage> createState() => _PartTimerMyInfoPageState();
}

class _PartTimerMyInfoPageState extends State<PartTimerMyInfoPage> {
  final PartTimerApi _partTimerApi = PartTimerApi();
  PartTimer? _partTimer;
  bool _isLoading = true;

  // 임시로 pno 값 하드 코딩!!!!!!!!!!!!!!
  // TODO: Provider 구현 후 제거 예정
  final int tempPno = 1;

  @override
  void initState() {
    super.initState();
    _loadPartTimerInfo();
  }

  Future<void> _loadPartTimerInfo() async {
    try {
      final partTimer = await _partTimerApi.getPartTimerDetail(tempPno);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
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
        ],
      ),
    );
  }
}
