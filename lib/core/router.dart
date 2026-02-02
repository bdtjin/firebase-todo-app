import 'package:firebase_todo_app/presentation/home/ui/detail/detail_page.dart';
import 'package:firebase_todo_app/presentation/home/ui/error/error_page.dart';
import 'package:firebase_todo_app/presentation/home/ui/home/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter 인스턴스만 정의하는 파일
// 앱 전체의 라우팅 설정을 관리하는 파일
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) {
    return ErrorPage();
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(title: '진파르타`s Tasks'),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
          final id = int.parse(state.pathParameters['id'] ?? '');
          return DetailPage(todoId: id.toString());
          },
        ),
      ],
    ),
  ],
);
