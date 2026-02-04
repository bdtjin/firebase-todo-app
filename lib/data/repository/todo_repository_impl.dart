import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/data/dto/mapper/todo_mapper.dart';
import 'package:firebase_todo_app/data/dto/todo_dto.dart';
import 'package:firebase_todo_app/domain/entity/todo_entity.dart';
import 'package:firebase_todo_app/domain/repository/todo_repository.dart';

// Data Layer (실제 데이터 저장소 구현) implement 작업
class TodoRepositoryImpl implements TodoRepository {
  final FirebaseFirestore _firestore;

  TodoRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Firebase 안에 있는 문서 생성 및 가져오는 작업
  @override
  Future<List<TodoEntity>> getTodos() async {
    final collectionRef = _firestore.collection('todos'); //  todos 라는거를 참조할거야
    final result = await collectionRef.get(); // 이거 가져올거야
    final docs = result.docs; // 문서 = 여러개의 문서가 들어가있음 (파이어베이스 안에 문서를 가져올거야)


    return result.docs.map((doc) {
      // Firebase 데이터를 DTO로 먼저 바꿈
      final dto = ToDoDto.fromJson(doc.data());
      // DTO를 Mapper를 통해 Entity로 변환해서 반환
      return dto.toDomain();
    }).toList();
  }

  // 1. 할 일 추가 (Insert) 구현
  @override
  Future<void> insert({required TodoEntity todo}) async {
    // 2) 컬렉션 참조 생성: todos 라는 이름의 폴더(컬렉션) 만듬
    final collectionRef = _firestore.collection('todos');
    // 3) 문서 참조 만들기: todos 컬렉션 안에 새 문서를 넣을 준비 (+id 값 바꿔치기)
    final docRef = collectionRef.doc(todo.id); // todo.id 값을 바꿔치기
    // 4) 직렬화하기 (json 형태로 변환)
    // Entity -> DTO -> JSON
    await docRef.set(todo.toDto().toJson());
  }

  // 2. 할 일 삭제 (delete) 구현
  @override
  Future<void> deleteToDo(String id) async {
    try {
      final collectionRef = _firestore.collection('todos');
      final docRef = collectionRef.doc(id);
      await docRef.delete();
    } catch (e) {
      print('삭제 실패 : $e');
    }
  }

  // 3. 업데이트 되게 할 (update) 구현
  @override
  Future<void> updateToDo({required TodoEntity todo}) async {
    final collectionRef = _firestore.collection('todos');
    final docRef = collectionRef.doc(todo.id);
    // Entity -> DTO -> JSON
    await docRef.update(todo.toDto().toJson());
  }

  // 4. 즐겨찾기 (leFavorite) 구현
  @override
  Future<void> toggleFavorite({required TodoEntity todo}) async {
    final collectionRef = _firestore.collection('todos');
    final docRef = collectionRef.doc(todo.id);
    await docRef.update({'isFavorite': todo.isFavorite});
  }
}
