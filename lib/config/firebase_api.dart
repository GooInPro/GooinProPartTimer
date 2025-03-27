import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  // Firebase Messaging 인스턴스 생성
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Flutter Local Notifications 인스턴스 생성
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // 알림 초기화
  Future<void> initNotifications() async {
    // 사용자에게 알림 권한 요청
    await _firebaseMessaging.requestPermission(
      badge: true,
      alert: true,
      sound: true,
    );

    // FCM 토큰 가져오기 (서버로 보내야 함)
    final fcmToken = await _firebaseMessaging.getToken();
    print('📌 FCM Token: $fcmToken');

    // 로컬 알림 설정
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 포그라운드에서 FCM 알림 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 포그라운드 알림 수신: ${message.notification?.title} - ${message.notification?.body}");
      _showNotification(message);
    });
  }

  // 푸시 알림 표시 함수
  void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', // 채널 ID
      'High Importance Notifications', // 채널 이름
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.notification?.title, // 알림 제목
      message.notification?.body, // 알림 내용
      platformChannelSpecifics,
    );
  }
}