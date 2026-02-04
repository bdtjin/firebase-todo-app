import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/core/provider.dart';

import 'package:firebase_todo_app/data/repository/todo_repository_impl.dart';
import 'package:firebase_todo_app/domain/entity/todo_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 생략 (todo_list_view.dart 구성했으니 생략)
// 2. ViewModel 구현
class HomeViewModel extends AsyncNotifier<List<TodoEntity>> {
  @override
  Future<List<TodoEntity>> build() async {
    return _getAllTodo();
  }

  // todo_repository를 가져오는 작업
  Future<List<TodoEntity>> _getAllTodo() async {
    return await ref.read(getTodoUseCaseProvider).execute();
  }

  // ViewModel - [할 일 추가]
  Future<void> addToDo({
    required String title,
    required String description,
    required bool isFavorite,
  }) async {
    final TodoEntity newTodo = TodoEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: title, 
      description: description, 
      isFavorite: isFavorite, 
      isDone: false,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addTodoUseCaseProvider).execute(todo: newTodo);
      
      // 현재 목록 가져오기
      final currentList = state.value ?? [];
      
      // 유즈케이스 실행
      await ref.read(addTodoUseCaseProvider).execute(todo: newTodo);
      
      // 새 목록 반환
      return [newTodo, ...currentList];
    });
  }

  // ViewModel - [할 일 삭제하기]
  Future<void> deleteToDo({required String id}) async {
    final currentList = state.value ?? [];
    
    // 현재 목록 가져오기
    state = await AsyncValue.guard(() async {
      await ref.read(deleteTodoUseCaseProvider).execute(id: id);
      return currentList.where((todo) => todo.id != id).toList();
    });
  }

  // ViewModel - [할 일 완료]
  Future<void> toggleDone({required bool isDone, required String id}) async {
    final currentList = state.value ?? [];
    final oldTodo = currentList.firstWhere((todo) => todo.id == id);
    final updateTodo = oldTodo.copyWith(isDone: isDone);
    
    state = await AsyncValue.guard(() async {
      await ref.read(updateTodoUseCaseProvider).execute(todo: updateTodo);
      return currentList.map((todo) => todo.id == id ? updateTodo : todo).toList();
    });
  }

  // ViewModel - [할 일 즐겨찾기]
  Future<void> toggleFavorite({required bool isFavorite, required String id}) async {
    final currentList = state.value ?? [];
    final oldTodo = currentList.firstWhere((todo) => todo.id == id);
    final updateTodo = oldTodo.copyWith(isFavorite: isFavorite);
    
    state = await AsyncValue.guard(() async {
      await ref.read(toggleFavoriteUseCaseProvider).execute(todo: updateTodo);
      return currentList.map((todo) => todo.id == id ? updateTodo : todo).toList();
    });
  }

  // ViewModel - [할 일 수정]
  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
    required bool isFavorite,
    required bool isDone,
  }) async {
    final currentList = state.value ?? [];
    final oldTodo = currentList.firstWhere((todo) => todo.id == id);
    final updatedTodo = oldTodo.copyWith(
      title: title,
      description: description,
      isFavorite: isFavorite,
      isDone: isDone,
    );

    state = await AsyncValue.guard(() async {
      await ref.read(updateTodoUseCaseProvider).execute(todo: updatedTodo);
      return currentList.map((todo) => todo.id == id ? updatedTodo : todo).toList();
    });
  }
}

// 3. 뷰모델 관리자 만들기
final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, List<TodoEntity>>(
  () {
    return HomeViewModel();
  },
);
