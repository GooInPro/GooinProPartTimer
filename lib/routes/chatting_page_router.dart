import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/chat_page.dart';

// Chatting 페이지 라우트 정의
final GoRoute chatPageRoute = GoRoute(
  path: '/chat',
  builder: (context, state) => ChatPage(),
);
