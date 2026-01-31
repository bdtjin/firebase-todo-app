
import 'package:firebase_todo_app/data/repository/todo_repository_impl.dart';
import 'package:firebase_todo_app/domain/repository/todo_repository.dart';
import 'package:firebase_todo_app/domain/use_case/get_todo_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 의존성 주입 모아두는 파일

// 1. 레포짙토리 주입
// 구현체인 Impl을 반환하지만 타입은 인터페이스인 TodoRepository로 반환
final todoRepositoryProvider = Provider<TodoRepository>((ref){
  return TodoRepositoryImpl();
});

// 2. 유즈케이스 주입 
final getTodoUseCaseProvider = Provider<GetTodoUseCase>((ref){
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodoUseCase(repository);
});

// 3. 할 일 추가 유즈케이스 주입
final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref){
  return AddTodoUseCase(ref.watch(todoRepositoryProvider));
});

// 4. 할 일 삭제 유즈케이스 주입
final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref){
  return DeleteTodoUseCase(ref.watch(todoRepositoryProvider));
});

// 5. 할 일 업데이트 유즈케이스 주입
final updateTodoUseCaseProvider = Provider<UpdateTodoUseCase>((ref){
  return UpdateTodoUseCase(ref.watch(todoRepositoryProvider));
});

// 6. 할 일 즐겨찾기 유즈케이스 주입
final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref){
  return ToggleFavoriteUseCase(ref.watch(todoRepositoryProvider));
});