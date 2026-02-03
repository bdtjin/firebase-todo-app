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

    // Optimistic update or wait for server?
    // Let's guard the operation
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addTodoUseCaseProvider).execute(todo: newTodo);
      // Re-fetch or manually update?
      // Manually update for efficiency if we trust the operation, but here we can just append to previous state if available.
      // However, simplified approach with guard essentially re-runs build or we just return the new list.
      // Let's implement manual append to avoid re-fetch if possible, BUT AsyncValue.guard expects a return of the new state type.
      // So we need to return the new list.
      // But we don't have the "previous" list easily inside guard if we don't capture it.
      
      // Better approach for simple CRUD without strict re-fetch requirements:
      // Just do the operation and then update state.
      // But we want to handle loading/error.
      
      // Let's stick to the previous logic but wrapped in AsyncValue
      // But simple refactor first:
      
      // 1. Get current list
      final currentList = state.value ?? [];
      
      // 2. Execute UseCase
      await ref.read(addTodoUseCaseProvider).execute(todo: newTodo);
      
      // 3. Return new list
      return [newTodo, ...currentList];
    });
  }

  // ViewModel - [할 일 삭제하기]
  Future<void> deleteToDo({required String id}) async {
    final currentList = state.value ?? [];
    
    // Optimistic: Update UI immediately (optional, but good for UX) -> Actually standard is guard.
    // Let's just do standard async update
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
