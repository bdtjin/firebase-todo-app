
import 'package:firebase_todo_app/domain/entity/todo_entity.dart';
import 'package:firebase_todo_app/domain/repository/todo_repository.dart';

// Use Case 구현
// 1. 할 일 가져오기 use case 구현
class GetTodoUseCase {
  GetTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<List<TodoEntity>> execute () async {
    final todos = await _repository.getTodos();
    return todos;
  }
}

// 2. 할 일 추가 use case 구현
class AddTodoUseCase {
  AddTodoUseCase(this._repository);
  final TodoRepository _repository;

  Future<void> execute({required TodoEntity todo}) async {
    await _repository.insert(todo: todo);
  }
}

// 3. 할 일 삭제 use case 구현
class DeleteTodoUseCase {
  DeleteTodoUseCase(this._repository);
  final TodoRepository _repository;

  Future<void> execute({required String id}) async {
    await _repository.deleteToDo(id);
  }
}

// 4. 할 일 완료 use case 구현
class UpdateTodoUseCase {
  UpdateTodoUseCase(this._repository);
  final TodoRepository _repository;

  Future<void> execute({required TodoEntity todo}) async {
    await _repository.updateToDo(todo: todo);
  }
}

// 할 일 즐겨찾기 use case 구현
class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repository);
  final TodoRepository _repository;

  Future<void> execute({required TodoEntity todo}) async {
    await _repository.toggleFavorite(todo: todo);
  }
}
