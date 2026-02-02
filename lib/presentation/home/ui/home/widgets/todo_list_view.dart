import 'package:firebase_todo_app/presentation/home/model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TodoListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 5. onToggle 대신 ViewModel 구현 완료 후 ref 작성
    // UI에서 이벤트 발생 시에 HomeViewModel 작성한 함수 실행
    final vm = ref.read(homeViewModelProvider.notifier);
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
              IconButton(      // 힐 일 완료 버튼
                onPressed: () {
                  vm.toggleDone(isDone: !item.isDone, id: item.id,); // 위에 만든 vm 함수 전달받아서 실행
                },
                icon: Icon(
                  item.isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: item.isDone ? Colors.green : Colors.grey,
                ),
              ),

              Expanded(
                // 클릭 이벤트 추가 (Go Router)
                child: GestureDetector(
                  onTap: () {
                    context.go('/detail/${item.id}');
                  },
                  child: Padding( // 클릭 시에 영역 확장
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(  // 할 일 Title 
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                        color: item.isDone ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              IconButton(    // 즐겨찾기 버튼
                onPressed: () {
                  vm.toggleFavorite(isFavorite: !item.isFavorite, id: item.id); // 위에 만든 vm 함수 전달받아서 실행
                },
                icon: Icon(
                  item.isFavorite ? Icons.star : Icons.star_border,
                  color: item.isFavorite ? Colors.amber : Colors.grey,
                ),
              ),

              IconButton(    // 삭제 버튼
                onPressed: () {
                  vm.deleteToDo(id: item.id); // 위에 만든 vm 함수 전달받아서 실행
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
