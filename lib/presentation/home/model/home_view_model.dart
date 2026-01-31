import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/core/provider.dart';
import 'package:firebase_todo_app/data/model/todo_dto.dart';
import 'package:firebase_todo_app/data/repository/todo_repository_impl.dart';
import 'package:firebase_todo_app/domain/entity/todo_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 생략 (todo_list_view.dart 구성했으니 생략)
// 2. ViewModel 구현
class HomeViewModel extends Notifier<List<TodoEntity>> {
  @override
  List<TodoEntity> build() {
    getAllTodo();
    return [];
  }

  // // Repository 인스턴스 생성해서 보유하기
  // final todoRepo = TodoRepository();

  // todo_repository를 가져오는 작업
  Future<void> getAllTodo() async {
    final todos = await ref.read(getTodoUseCaseProvider).execute();
    state = todos;
  }

  // ViewModel - [할 일 추가]
  Future<void> addToDo({
    required String title,
    required String description,
    required bool isFavorite,
  }) async {
    // todos collection 들어갈 아이디를 만든기 -> firebase에 들어갈 아이디 값을 미리 정함
    // final docId = FirebaseFirestore.instance.collection('todos').doc().id;
    // final ToDoEntity newtodo = ToDoEntity(
    //   id: docId, // ⭐️ 임의로 id 넣어줌
    //   title: title,
    //   description: description,
    //   isFavorite: isFavorite,
    //   isDone: false,
    // );
    //  await todoRepo.insert(todo: newtodo); // 저장하는 역할 *할일 추가
    // state = [newtodo, ...state]; // UI 상태에 반영하는 작업
    // await todoRepo.getTodos();

    final TodoEntity newTodo = TodoEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: title, 
      description: description, 
      isFavorite: isFavorite, 
      isDone: false,
      );

      await ref.read(addTodoUseCaseProvider).execute(todo: newTodo);
      state = [newTodo, ...state];
  }

  // // ViewModel - [할 일 삭제하기]
  // Future<void> deleteToDo({required String id}) async {
  //   print('삭제 요청 아이디: ${id}');
  //   await todoRepo.deleteToDo(id); // 삭제하는 작업
  //   // UI 상태에 반영하는 작업 + delete는 Id 값빼고 상태에 반영해줘야함
  //   state = state.where((todo) => todo.id != id).toList();
  // }

  // ViewModel - [할 일 삭제하기]
  Future<void> deleteToDo({required String id}) async {
    await ref.read(deleteTodoUseCaseProvider).execute(id: id);
    state = state.where((todo) => todo.id != id).toList();
  }


  // // ViewModel - [할 일 완료]
  // Future<void> toggleDone({required bool isDone, required String id}) async {
  //   // newTodo = id가 같은 투두가 담김
  //   final newTodo = state.firstWhere((todo) => todo.id == id);
  //   final updateTodo = newTodo.copyWith(isDone: isDone); // 받아온 id만 newTodo로 바꿔줌
  //   await todoRepo.updateToDo(todo: updateTodo);
  //   state = state.map((todo) => todo.id == id ? updateTodo : todo).toList();
  // }

  // ViewModel - [할 일 완료]
  Future<void> toggleDone({required bool isDone, required String id}) async {
    final newTodo = state.firstWhere((todo) => todo.id == id);
    final updateTodo = newTodo.copyWith(isDone: isDone);
    await ref.read(updateTodoUseCaseProvider).execute(todo: updateTodo);
    state = state.map((todo) => todo.id == id ? updateTodo : todo).toList();
  }

  // // ViewModel - [할 일 즐겨찾기]
  // Future<void> toggleFavorite({required bool isFavorite, required String id}) async {
  //   final newTodo = state.firstWhere((todo) => todo.id == id);
  //   final leFavoriteTodo = newTodo.copyWith(isFavorite: isFavorite);
  //   await todoRepo.toggleFavorite(todo: leFavoriteTodo);
  //   state = state.map((todo) => todo.id == id? leFavoriteTodo : todo).toList();
  // }

  // ViewModel - [할 일 즐겨찾기]
  Future<void> toggleFavorite({required bool isFavorite, required String id}) async {
    final newTodo = state.firstWhere((todo) => todo.id == id);
    final leFavoriteTodo = newTodo.copyWith(isFavorite: isFavorite);
    await ref.read(toggleFavoriteUseCaseProvider).execute(todo: leFavoriteTodo);
    state = state.map((todo) => todo.id == id? leFavoriteTodo : todo).toList();
  }
  
}

// // 3. 뷰모델 관리자 만들기
// final homeViewModelProvider = NotifierProvider<HomeViewModel, List<TodoEntity>>(
//   () {
//     return HomeViewModel();
//   },
// );

// 3. 뷰모델 관리자 만들기
final homeViewModelProvider = NotifierProvider<HomeViewModel, List<TodoEntity>>(
  () {
    return HomeViewModel();
  },
);
