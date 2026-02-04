import 'package:firebase_todo_app/data/dto/todo_dto.dart';

import '../../../domain/entity/todo_entity.dart';


// DTO -> Entity
// 기존의 DTO를 Domain Entity로 변환해주는 작업
extension ToDomain on ToDoDto {
  TodoEntity toDomain() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      isFavorite: isFavorite,
      isDone: isDone,
    );
  }
}

// Entity -> DTO
// 기존의 Entity를 DTO로 변환해주는 작업
extension ToDto on TodoEntity {
  ToDoDto toDto() {
    return ToDoDto(
      id: id,
      title: title,
      description: description,
      isFavorite: isFavorite,
      isDone: isDone,
    );
  }
}
