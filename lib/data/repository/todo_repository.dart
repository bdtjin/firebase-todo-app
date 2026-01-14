import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo_app/data/model/todo_entity.dart';
import 'package:flutter/material.dart';

// Repository 저장소 정의를 하는 공간
class TodoRepository {
  // 문서 생성 과정
  Future<List<ToDoEntity>?> getTodos() async {
    // try {
      FirebaseFirestore firestore = FirebaseFirestore.instance; // 파이어베이스 가져올거야
      final collectionRef = firestore.collection('todos'); //  todos 라는거를 참조할거야
      final result = await collectionRef.get(); // 이거 가져올거야
      final docs = result.docs; // 문서 = 여러개의 문서가 들어가있음 (파이어베이스 안에 문서를 가져올거야)

      return docs.map((todo) {
        // docs를 fromJson해서 아이디랑 데이터랑 합쳐주는 작업
        // final map = {'id': todo.id, ...todo.data()};
        // print('가져온 데이터: ${todo.data()}');
        // print('새로운 맵: ${map}');
        return ToDoEntity.fromJson(todo.data());
      }).toList();
    // } 
    // catch (e) {
    //   print(e);
    // }
  }

  // 1. 할 일 추가 (Insert) 함수 구현
  // id, title, description, favorite, isDone => firebase에 저장해줘!
  Future<void> insert({required ToDoEntity todo}) async {
    // 1) Firestore 인스턴스를 가져오기 (이제 데이터베이스 접근 권한 가짐)
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 2) 컬렉션 참조 생성: todos 라는 이름의 폴더(컬렉션) 만듬
    final collectionRef = firestore.collection('todos');
    // 3) 문서 참조 만들기: todos 컬렉션 안에 새 문서를 넣을 준비 (+id 값 바꿔치기)
    final docRef = collectionRef.doc(todo.id); // todo.id 값을 바꿔치기
    // 4) 직렬화하기 (json 형태로 변환)
    await docRef.set(todo.toJson());
  }

  // 2. 할 일 삭제 (Insert) 함수 구현
  Future<void> deleteToDo(String id) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final collectionRef = firestore.collection('todos');
      final docRef = collectionRef.doc(id);
      await docRef.delete();
    } catch (e) {
      print('삭제 실패 : $e');
    }
  }

  // 3. 업데이트 되게 할 (Insert) 함수 구현
  Future<void> updateToDo({required ToDoEntity todo}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('todos');
    final docRef = collectionRef.doc(todo.id);
    await docRef.update(todo.toJson());
  }

  // 4. 즐겨찾기 (Insert) 함수 구현
  Future<void> toggleFavorite({required ToDoEntity todo}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('todos');
    final docRef = collectionRef.doc(todo.id);
    await docRef.update({'isFavorite': todo.isFavorite});
  }
}
