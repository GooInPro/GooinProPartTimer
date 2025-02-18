import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/screens/chat_screens/chat_list_page.dart';
import 'package:gooinpro_parttimer/screens/chat_screens/chat_page.dart';

// Chatting 페이지 라우트 정의
final GoRoute chatPageRoute = GoRoute(
  path: '/chat/:email',
  builder: (context, state) {
    final email = state.pathParameters['email'] ?? '';
    print(email);
    return ChatListPage(email: email);
  },
  routes: [
    GoRoute(
      path: 'chatting/:id',
      builder: (context, state) {
        final email = state.pathParameters['email'] ?? '';
        final id = state.pathParameters['id'] ?? '';
        print(id);
        return ChatPage(email: email, id: id);
      },
    ),
  ],
);
