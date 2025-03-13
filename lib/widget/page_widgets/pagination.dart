import 'package:flutter/material.dart';

class Pagination extends StatelessWidget { // 페이지 위젯 사용법은 jobpostings_page 한번 보세요 순서 적어둘게요
  final int currentPage;
  final int totalPages;
  final bool prev;
  final bool next;
  final Function(int) onPageChanged;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.prev,
    required this.next,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prev)
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              onPageChanged(currentPage - 1);
            },
          ),
        // Page number buttons
        for (int i = 1; i <= totalPages; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                onPageChanged(i); // 페이지 번호 클릭 시 호출
              },
              child: Text('$i'),
              style: ElevatedButton.styleFrom(
                foregroundColor: currentPage == i ? Colors.white : Colors.blueAccent,
                backgroundColor: currentPage == i ? Colors.blueAccent : Colors.white,
              ),
            ),
          ),
        // Next button
        if (next)
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              onPageChanged(currentPage + 1);
            },
          ),
      ],
    );
  }
}