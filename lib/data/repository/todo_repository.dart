import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/data/model/todo_entity.dart';

// Repository 저장소 정의를 하는 공간
class TodoRepository {
  // Firebase 안에 있는 문서 생성 및 가져오는 작업
  Future<List<ToDoEntity>?> getTodos() async {
      FirebaseFirestore firestore = FirebaseFirestore.instance; // 파이어베이스 가져올거야
      final collectionRef = firestore.collection('todos'); //  todos 라는거를 참조할거야
      final result = await collectionRef.get(); // 이거 가져올거야
      final docs = result.docs; // 문서 = 여러개의 문서가 들어가있음 (파이어베이스 안에 문서를 가져올거야)

      return docs.map((todo) {
        return ToDoEntity.fromJson(todo.data());
      }).toList();
  }

  // 1. 할 일 추가 (Insert) 구현
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

  // 2. 할 일 삭제 (delete) 구현
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

  // 3. 업데이트 되게 할 (update) 구현
  Future<void> updateToDo({required ToDoEntity todo}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('todos');
    final docRef = collectionRef.doc(todo.id);
    await docRef.update(todo.toJson());
  }

  // 4. 즐겨찾기 (leFavorite) 구현
  Future<void> toggleFavorite({required ToDoEntity todo}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('todos');
    final docRef = collectionRef.doc(todo.id);
    await docRef.update({'isFavorite': todo.isFavorite});
  }
}
