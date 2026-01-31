
class TodoEntity {
  final String id;
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;

  TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
    required this.isDone,
  });

  // 상태 변경을 위해 필요한 copyWith
  TodoEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    bool? isDone,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isDone: isDone ?? this.isDone,
    );
  }
}