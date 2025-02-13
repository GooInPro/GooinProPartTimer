
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String message; //msg
  final bool isMe;  //내 채팅인지

  ChatMessage({required this.message, this.isMe = false});

  @override
  Widget build(BuildContext context) {

    return Align(

      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(

        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black)
        )
      )
    );
  }

}