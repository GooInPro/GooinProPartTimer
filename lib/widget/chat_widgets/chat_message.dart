import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 시간 포맷을 위한 패키지

class ChatMessage extends StatelessWidget {
  final String message; // 메시지 내용
  final bool isMe; // 내가 보낸 메시지인지 여부
  final DateTime timestamp; // 보낸 시간

  ChatMessage({
    required this.message,
    this.isMe = false,
    required this.timestamp, // 보낸 시간 필드 추가
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('HH:mm').format(timestamp); // "시:분" 형식

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[200] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Text(
              formattedTime, // 포맷된 시간 표시
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
