import 'package:firebase_todo_app/domain/entity/todo_entity.dart';
import 'package:firebase_todo_app/presentation/home/model/home_view_model.dart';
import 'package:firebase_todo_app/presentation/home/ui/home/widgets/no_todo.dart';
import 'package:firebase_todo_app/presentation/home/ui/home/widgets/todo_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// 데이터가 없을 때와 있을 때 TodoListView 위젯이 화면을 잘 그리는지 위젯테스트

// HomeViewModel의 인터페이스를 따르는 가짜 클래스
class MockHomeViewModel extends AsyncNotifier<List<TodoEntity>> 
    implements HomeViewModel {
  @override
  Future<List<TodoEntity>> build() async {
    return [];
  }

  @override
  Future<void> addToDo({required String title, required String description, required bool isFavorite}) async {}
  @override
  Future<void> deleteToDo({required String id}) async {}
  @override
  Future<void> toggleDone({required bool isDone, required String id}) async {}
  @override
  Future<void> toggleFavorite({required bool isFavorite, required String id}) async {}
  @override
  Future<void> updateTodo({required String id, required String title, required String description, required bool isFavorite, required bool isDone}) async {}
}

void main() {
  group('TodoListView Widget Test (Simplified)', () {
    
    // 1. 데이터가 비었을 때
    testWidgets('데이터가 없을 때 NoTodo 위젯이 보여야 함', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
             homeViewModelProvider.overrideWith(() => _EmptyMockHomeViewModel()),
          ],
          child: MaterialApp(
            home: Scaffold(body: TodoListView()),
          ),
        ),
      );
      
      // 비동기 데이터 로딩 끝날 때까지 대기
      await tester.pumpAndSettle();
      // 화면에 NoTodo라는 타입 위젯이 있는지 검사
      expect(find.byType(NoTodo), findsOneWidget);
    });

    // 2. 데이터가 있을 때
    testWidgets('데이터가 있을 때 리스트가 보여야 함', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
             homeViewModelProvider.overrideWith(() => _DataMockHomeViewModel()),
          ],
          child: MaterialApp(
            home: Scaffold(body: TodoListView()),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      // 지정한 텍스트들이 화면에 나타났는지 검사
      expect(find.text('Test Todo 1'), findsOneWidget);
      expect(find.text('Test Todo 2'), findsOneWidget);
      // 목록을 보여주는 ListView 위젯이 생성되었는지 검사
      expect(find.byType(ListView), findsOneWidget);
    });

  });
}

class _EmptyMockHomeViewModel extends AsyncNotifier<List<TodoEntity>> implements HomeViewModel {
  @override
  Future<List<TodoEntity>> build() async {
    return [];
  }
   // Stub other methods
  @override
  Future<void> addToDo({required String title, required String description, required bool isFavorite}) async {}
  @override
  Future<void> deleteToDo({required String id}) async {}
  @override
  Future<void> toggleDone({required bool isDone, required String id}) async {}
  @override
  Future<void> toggleFavorite({required bool isFavorite, required String id}) async {}
  @override
  Future<void> updateTodo({required String id, required String title, required String description, required bool isFavorite, required bool isDone}) async {}
}

class _DataMockHomeViewModel extends AsyncNotifier<List<TodoEntity>> implements HomeViewModel {
  @override
  Future<List<TodoEntity>> build() async {
    return [
      TodoEntity(id: '1', title: 'Test Todo 1', description: 'desc1', isDone: false, isFavorite: false),
      TodoEntity(id: '2', title: 'Test Todo 2', description: 'desc2', isDone: true, isFavorite: true),
    ];
  }
   // Stub other methods
  @override
  Future<void> addToDo({required String title, required String description, required bool isFavorite}) async {}
  @override
  Future<void> deleteToDo({required String id}) async {}
  @override
  Future<void> toggleDone({required bool isDone, required String id}) async {}
  @override
  Future<void> toggleFavorite({required bool isFavorite, required String id}) async {}
  @override
  Future<void> updateTodo({required String id, required String title, required String description, required bool isFavorite, required bool isDone}) async {}
}
