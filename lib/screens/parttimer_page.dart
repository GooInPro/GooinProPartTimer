// import 'package:flutter/material.dart';
// import '../models/parttimer/parttimer_model.dart';
// import '../services/api/parttimerapi/parttimer_api.dart';
//
// class PartTimerScreen extends StatefulWidget {
//   const PartTimerScreen({super.key});
//
//   @override
//   State<PartTimerScreen> createState() => _PartTimerScreenState();
// }
//
// class _PartTimerScreenState extends State<PartTimerScreen> {
//   final PartTimerApi _partTimerApi = PartTimerApi();
//   PartTimer? _partTimer;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPartTimerInfo();
//   }
//
//   Future<void> _loadPartTimerInfo() async {
//     try {
//       // TODO: pno를 실제 사용자 ID로 변경해야 함
//       final partTimer = await _partTimerApi.getPartTimerDetail(1);
//       setState(() {
//         _partTimer = partTimer;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       // TODO: 에러 처리
//       print('Error loading parttimer info: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (_partTimer == null) {
//       return const Center(child: Text('사용자 정보를 불러올 수 없습니다.'));
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('마이 페이지'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 프로필 섹션
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('이름: ${_partTimer!.pname}'),
//                     Text('이메일: ${_partTimer!.pemail}'),
//                     Text('생년월일: ${_partTimer!.pbirth.toString().split(' ')[0]}'),
//                     Text('성별: ${_partTimer!.pgender ? '남성' : '여성'}'),
//                     if (_partTimer!.proadAddress != null)
//                       Text('도로명 주소: ${_partTimer!.proadAddress}'),
//                     if (_partTimer!.pdetailAddress != null)
//                       Text('상세 주소: ${_partTimer!.pdetailAddress}'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // 메뉴 버튼들
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: 정보 수정 화면으로 이동
//               },
//               child: const Text('개인정보 수정'),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () async {
//                 // TODO: 계정 삭제 확인 다이얼로그 추가
//                 try {
//                   await _partTimerApi.deactivateAccount(_partTimer!.pno);
//                   // TODO: 로그아웃 처리
//                 } catch (e) {
//                   // TODO: 에러 처리
//                   print('Error deactivating account: $e');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               child: const Text('계정 삭제'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
