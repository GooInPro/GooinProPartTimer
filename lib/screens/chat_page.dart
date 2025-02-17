import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/widget/chat_widgets/chat_message.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../widget/chat_widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  StompClient? _stompClient;
  late String _user;
  late String _roomId;

  @override
  void initState() {

    super.initState();

    //지금은 테스트용, 나중에 수정
    _user = "test23@email.com";
    _roomId = "67a2fdf8207c437b9f394653";

    _connectWebSocket();
  }

  void _connectWebSocket() {

    final socketUrl = "ws://localhost:8080/ws";
    final client = StompClient(
        config: StompConfig(
          url: socketUrl,
          onConnect: (StompFrame frame) {
            print("Connected to WebSocket");
            _subscribeToChatRoom();
          },
          onDisconnect: (_) {
            print("Disconnected from WebSocket");
          }
        ));

    setState(() {

      _stompClient = client;
    });

    _stompClient!.activate();
  }

  void _subscribeToChatRoom() {

    _stompClient!.subscribe(
      destination: "/topic/chat/$_roomId",
      callback: (StompFrame frame) {

        if (frame.body != null) {
          final Map<String, dynamic> messageData = jsonDecode(frame.body!);

          setState(() {
            _messages.insert(0, {
              "text": messageData["message"], // 'message' 필드만 사용
              "isMe": messageData["senderEmail"] == _user, // 내가 보낸 메시지인지 확인
            });
          });
        }
      }
    );
  }

  void _sendMessage(String text) {

    if(text.trim().isEmpty) return;

    final messageBody = {

      "roomId": _roomId,
      "senderEmail": _user,
      "message": text,
    };
    _stompClient!.send(
      destination: "/app/chat.sendMessage",
      body: jsonEncode(messageBody),
    );

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {

    Future.delayed(Duration(milliseconds: 100), () {

      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {

    super.dispose();
    _stompClient?.deactivate(); //WebSocket 연결 종료
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("채팅 테스트")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessage(
                  message: _messages[index]["text"],
                  isMe: _messages[index]["isMe"],
                );
              }
            )
          ),
          ChatInput(controller: _controller, onSend: _sendMessage),
        ]
      )
    );
  }
}
