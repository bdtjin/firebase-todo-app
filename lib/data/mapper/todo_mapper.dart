import '../../domain/entity/todo_entity.dart';
import '../model/todo_dto.dart';

// DTO -> Entity
// Mapper : 기존의 dto를 entity로 변환해주는 역할
// 유지 보수가 쉽고 확장이 가능한 전문적인 구조를 사용할 때 변환 로직
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
