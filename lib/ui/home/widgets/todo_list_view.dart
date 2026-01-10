import 'package:firebase_todo_app/data/model/todo_entity.dart';
import 'package:flutter/material.dart';

class TodoListView extends StatelessWidget {
  // 2. 데이터 
  final List<ToDoEntity> todo;
  final Function(int index) onToggleFavorite;
  final Function(int index) onToggleleDone;
  final Function(int index) onToggleDelete;

  // 3. 생성자 만들기 
  const TodoListView({
    required this.todo,
    required this.onToggleFavorite,
    required this.onToggleleDone,
    required this.onToggleDelete,
  });

  @override
  Widget build(BuildContext context) {

    // 1. todo Container 작업 -> ListView.builder 씌우기
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      itemCount: todo.length,
      itemBuilder: (context, index) {
        final item = todo[index]; // 데이터 순서 변수에 담기
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),

          // 4. 아이콘 생성 및 데이터 전달 작업
          child: Row(
            children: [
              IconButton( // 완료버튼
                onPressed: () => onToggleleDone(index),
                icon: Icon(
                  item.isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: item.isDone ? Colors.green : Colors.grey,
                ),
              ),
              Expanded(
                child: Text( // 할일 제목
                  item.title, 
                  style: TextStyle(
                    fontSize: 16,
                    decoration: item.isDone ? TextDecoration.lineThrough : null,
                  color: item.isDone ? Colors.grey : Colors.black,
                    ),
                ),
                ),
                
              IconButton( // 즐겨찾기 
                onPressed: () => onToggleFavorite(index),
                icon: Icon(
                  item.isFavorite ? Icons.star : Icons.star_border,
                  color: item.isFavorite ? Colors.amber : Colors.grey,
                ),
              ),
              IconButton( // 삭제
                onPressed: () => onToggleDelete(index),
                icon: Icon(Icons.delete_outline, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
