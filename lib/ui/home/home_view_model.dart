// 1. 생략

// 2. 뷰모델 만들기
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/data/model/todo_entity.dart';
import 'package:firebase_todo_app/data/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // UI에서 호출하게 될 할 일 추가하는 함수 만들기
  Future<ToDoEntity?> addToDo({
    required String title,
    required String description,
    required bool isFavorite,
    }) async {
      // todos collection 에서 미리 아이디를 만든다. -> firebase에 들어갈 아이값을 미리 정함
      final docId = FirebaseFirestore.instance.collection('todos').doc().id;
      final ToDoEntity newtodo = ToDoEntity(
      id: docId, 
      title: title, 
      description: description, 
      isFavorite: isFavorite, 
      isDone: false
      );
    await todoRepo.insert(todo: newtodo); // 저장하는 역할 *할일 추가
    state = [newtodo,...state]; // * UI 상태에 반영하는 작업
    await todoRepo.getTodos();
  }

  Future<void> toggleFavorite({required bool isFavorite}) async {}
  Future<void> toggleDone({required bool isDone}) async {}
  Future<void> deleteToDo({required String id}) async {
    print('삭제 요청 아이디: ${id}');
    await todoRepo.deleteToDo(id); // 삭제하는 작업
    // UI 상태에 반영하는 작업 + delete는 Id 값빼고 상태에 반영해줘야함
    state = state.where((todo) => todo.id != id).toList();
  }
}

// 3. 뷰모델 관리자 만들기
final homeViewModelProvider = NotifierProvider<HomeViewModel, List<ToDoEntity>>(
  () {
    return HomeViewModel();
  },
);
