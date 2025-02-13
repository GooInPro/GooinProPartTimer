
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {

  final TextEditingController controller;
  final Function(String) onSend;

  ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "메세지를 입력하세요", border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if(controller.text.trim().isNotEmpty) {
                onSend(controller.text.trim());
              }
            },
          )
        ],
      )
    );
  }
}