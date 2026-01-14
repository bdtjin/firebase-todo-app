import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/data/model/todo_entity.dart';
import 'package:firebase_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 생략 (todo_list_view.dart 구성했으니 생략)
// 2. ViewModel 구현
class HomeViewModel extends Notifier<List<ToDoEntity>> {
  @override
  List<ToDoEntity> build() {
    getAllTodo();
    return [];
  }

  // Repository 인스턴스 생성해서 보유하기
  final todoRepo = TodoRepository();

  // 투두레포지토리를 가져오는 작업
  Future<void> getAllTodo() async {
    final todos = await todoRepo.getTodos();
    state = todos ?? [];
  }

  // ViewModel - 할 일 추가
  Future<ToDoEntity?> addToDo({
    required String title,
    required String description,
    required bool isFavorite,
  }) async {
    // todos collection 에서 미리 아이디를 만든다. -> firebase에 들어갈 아이값을 미리 정함
    final docId = FirebaseFirestore.instance.collection('todos').doc().id;
    final ToDoEntity newtodo = ToDoEntity(
      id: docId, // 임의로 id 넣어줌
      title: title,
      description: description,
      isFavorite: isFavorite,
      isDone: false,
    );
    await todoRepo.insert(todo: newtodo); // 저장하는 역할 *할일 추가
    state = [newtodo, ...state]; // * UI 상태에 반영하는 작업
    await todoRepo.getTodos();
  }

  // ViewModel - 할 일 삭제하기
  Future<void> deleteToDo({required String id}) async {
    print('삭제 요청 아이디: ${id}');
    await todoRepo.deleteToDo(id); // 삭제하는 작업
    // UI 상태에 반영하는 작업 + delete는 Id 값빼고 상태에 반영해줘야함
    state = state.where((todo) => todo.id != id).toList();
  }

  // ViewModel - 할 일 완료
  Future<void> toggleDone({required bool isDone, required String id}) async {
    // newTodo = id가 같은 투두가 담김
    final newTodo = state.firstWhere((todo) => todo.id == id);
    final updateTodo = newTodo.copyWith(isDone: isDone); // 받아온 id만 newTodo로 바꿔줌
    await todoRepo.updateToDo(todo: updateTodo);
    state = state.map((todo) => todo.id == id ? updateTodo : todo).toList();
  }

  // ViewModel - 할 일 즐겨찾기
  Future<void> toggleFavorite({required bool isFavorite, required String id}) async {
    final newTodo = state.firstWhere((todo) => todo.id == id);
    final leFavoriteTodo = newTodo.copyWith(isFavorite: isFavorite);
    await todoRepo.toggleFavorite(todo: leFavoriteTodo);
    state = state.map((todo) => todo.id == id? leFavoriteTodo : todo).toList();
  }
}

// 3. 뷰모델 관리자 만들기
final homeViewModelProvider = NotifierProvider<HomeViewModel, List<ToDoEntity>>(
  () {
    return HomeViewModel();
  },
);
