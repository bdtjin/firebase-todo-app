
import 'package:firebase_todo_app/domain/entity/todo_entity.dart';

// Domain Layer (추상적인 저장소만들기) interface 작업
abstract interface class TodoRepository {
  Future<List<TodoEntity>> getTodos();
  Future<void> insert({required TodoEntity todo});
  Future<void> deleteToDo(String id);
  Future<void> updateToDo({required TodoEntity todo});
  Future<void> toggleFavorite({required TodoEntity todo});
}