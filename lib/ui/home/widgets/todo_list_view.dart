import 'package:firebase_todo_app/data/model/todo_entity.dart';
import 'package:firebase_todo_app/ui/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListView extends ConsumerWidget {
  // 2. 데이터 정의 (완료 시 실행할 함수)
  // final List<ToDoEntity> todo;
  // final Function(int index) onToggleFavorite;
  // final Function(int index) onToggleleDone;
  // final Function(int index) onToggleDelete;

  // // 3. 생성자 만들기 
  // const TodoListView({
  //   required this.todo,
  //   // required this.onToggleFavorite,
  //   // required this.onToggleleDone,
  //   // required this.onToggleDelete,
  // });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(homeViewModelProvider.notifier); //// 완료 ViewModel 구현 후 구독
    final todos = ref.watch(homeViewModelProvider);

    // 1. todo Container 작업 -> ListView.builder 씌우기
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final item = todos[index]; // 데이터 순서 변수에 담기
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
              IconButton( // 완료버튼
                onPressed: () {
                  vm.toggleDone(isDone: !item.isDone, id: item.id);
                },
                icon: Icon(
                  item.isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: item.isDone ? Colors.green : Colors.grey,
                ),
              ),
                
              IconButton( // 즐겨찾기 
                onPressed: () {
                  vm.toggleFavorite(isFavorite: !item.isFavorite, id: item.id);
                },
                icon: Icon(
                  item.isFavorite ? Icons.star : Icons.star_border,
                  color: item.isFavorite ? Colors.amber : Colors.grey,
                ),
              ),

              IconButton( // 삭제
                onPressed: () {
                  print('UI 에서 삭제 버튼 클릭');  
                  vm.deleteToDo(id: item.id);
                  },
                icon: Icon(Icons.delete_outline, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
