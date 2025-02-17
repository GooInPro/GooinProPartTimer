
//채팅방 리스트 model
class ChatRoomList {

  final String id;  //채팅방 id
  final String roomName;  //채팅방 이름
  final String? message; //마지막 메세지 내용
  final DateTime? sentAt;  //마지막 메세지 시간

  ChatRoomList({
    required this.id,
    required this.roomName,
    this.message,
    this.sentAt,
  });

  //JSON Data -> Dart 객체
  factory ChatRoomList.fromJson(Map<String, dynamic> json) {
    return ChatRoomList(
      id: json['id'] as String,
      roomName: json['roomName'] as String,
      message: json['message'] as String?,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }
}