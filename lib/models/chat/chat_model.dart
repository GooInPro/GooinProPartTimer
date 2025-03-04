
//채팅방 리스트 model
class ChatRoomListModel {

  final String id;  //채팅방 id
  final String roomName;  //채팅방 이름
  final String? message; //마지막 메세지 내용
  final DateTime? sentAt;  //마지막 메세지 시간

  ChatRoomListModel({
    required this.id,
    required this.roomName,
    this.message,
    this.sentAt,
  });

  //JSON Data -> Dart 객체
  factory ChatRoomListModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomListModel(
      id: json['id'] as String,
      roomName: json['roomName'] as String,
      message: json['message'] as String?,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }
}

//채팅 메세지 model
class CHatMessageModel {

  final String roomId;  //채팅방 id
  final String senderEmail; //보낸 사람 email;
  final String message; //message
  final DateTime sentAt;  //보낸 시간

  CHatMessageModel({
    required this.roomId,
    required this.senderEmail,
    required this.message,
    required this.sentAt,
  });

  factory CHatMessageModel.fromJson(Map<String, dynamic> json) {
    return CHatMessageModel(
      roomId: json['roomId'] as String,
      senderEmail: json['senderEmail'] as String,
      message: json['message'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }
}