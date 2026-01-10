

class ToDoEntity {
  ToDoEntity({
    required this.title,
    required this.description,
    required this.isFavorite,
    required this.isDone,
  });

  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;

  // 데이터 변경 시에 데이터에 일부만 변경 후 새로운 객체 데이터로 만듬
  // copyWith: 특정 값만 바꿔서 새로운 복사본을 만드는 함수
  ToDoEntity copyWith ({
    String? title,
    String? description,
    bool? isFavorite,
    bool? isDone,
  }) {
    return ToDoEntity(
      title: title ?? this.title, 
      description: description ?? this.description, 
      isFavorite: isFavorite ?? this.isFavorite, 
      isDone: isDone ?? this.isDone,
      );
  }

  @override
  String toString() {
    return 'ToDo(title: $title, description: $description, isFavorite: $isFavorite, isDone: $isDone)';
  }
}
