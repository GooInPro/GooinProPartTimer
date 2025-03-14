import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    List<ChatRoomListModel> chatRoomList =
    await chat_api().getChatRoomListAPI(email: widget.email);

    if (mounted) {
      setState(() {
        chatRoom = chatRoomList;
        isLoading = false;
      });
    }
  }

  /// `sentAt` 날짜를 상대적 또는 포맷된 문자열로 변환
  String formatDate(DateTime? date) {
    if (date == null) return "";
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('a h:mm', 'ko_KR').format(date); // "오후 3:45"
    } else if (difference.inDays == 1) {
      return "어제";
    } else {
      return DateFormat('yyyy-MM-dd').format(date); // "2024-03-10"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(// 배경색 변경
      appBar: AppBar(
        title: Text("채팅방 목록"),
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : chatRoom.isEmpty
          ? Center(
        child: Text(
          "참여한 채팅방이 없습니다.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        itemCount: chatRoom.length,
        itemBuilder: (context, index) {
          final room = chatRoom[index];

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              title: Text(
                room.roomName,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.message ?? '최근 메시지가 없습니다.',
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(room.sentAt),
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  room.roomName.isNotEmpty
                      ? room.roomName[0]
                      : '?', // 방 이름 첫 글자 표시
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey[400]),
              onTap: () {
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
            ),
          );
        },
      ),
    );
  }
}
