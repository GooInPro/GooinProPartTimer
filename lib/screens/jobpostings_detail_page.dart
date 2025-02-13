import 'package:flutter/material.dart';

class JobPostingDetailPage extends StatelessWidget {
  final int jpno;

  const JobPostingDetailPage({Key? key, required this.jpno}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // JobPostingDetailPage에서 jpno를 사용하여 상세 정보를 처리
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posting Detail'),
      ),
      body: Center(
        child: Text('Job Posting No: $jpno'), // jpno를 표시
      ),
    );
  }
}