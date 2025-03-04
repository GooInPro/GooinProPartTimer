
import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/chat/chat_model.dart';
import 'package:gooinpro_parttimer/services/api/chatapi/chat_api.dart';

import 'chat_page.dart';

class ChatListPage extends StatefulWidget {

  final String email;
  const ChatListPage({Key? key, required this.email}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  bool isLoading = true;
  List<ChatRoomListModel> chatRoom = [];

  @override
  void initState() {

    super.initState();
    _fetchChatRoomList();
  }

  Future<void> _fetchChatRoomList() async {

    List<ChatRoomListModel> chatRoomList = await chat_api().getChatRoomListAPI(email: widget.email);

    if(mounted) {

      setState(() {
        chatRoom = chatRoomList;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("채팅방 목록")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : chatRoom.isEmpty
          ? Center(child: Text("참여한 채팅방이 없습니다."))
          : ListView.builder(
        itemCount: chatRoom.length,
        itemBuilder: (context, index) {
          final room = chatRoom[index];

          return ListTile(
            title: Text(room.roomName),
            subtitle: Text(room.message ?? ''),
            leading: CircleAvatar(
              child: Icon(Icons.chat),
            ),
            onTap: () {
              // 채팅방 클릭 시 ChatPage로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    email: widget.email,
                    id: room.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}