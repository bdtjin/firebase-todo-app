import 'package:firebase_todo_app/presentation/home/model/home_view_model.dart';
import 'package:firebase_todo_app/presentation/home/ui/home/widgets/bottom_add_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({super.key, required this.todoId});

  final String todoId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(homeViewModelProvider);
    final todo = todos.firstWhere((e) => e.id == todoId);

    return Scaffold(
      appBar: AppBar(
        // Hero 위젯 추가 (동일한 tag 적용)
        title: Hero(
          tag: 'todo-title-${todo.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              todo.title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(homeViewModelProvider.notifier)
                  .toggleDone(isDone: !todo.isDone, id: todo.id);
            },
            icon: Icon(
              todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: todo.isDone ? Colors.green : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              ref
                  .read(homeViewModelProvider.notifier)
                  .toggleFavorite(isFavorite: !todo.isFavorite, id: todo.id);
            },
            icon: Icon(
              todo.isFavorite ? Icons.star : Icons.star_border,
              color: todo.isFavorite ? Colors.amber : Colors.grey,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '완료 여부 : ${todo.isDone ? "완료" : "미완료"}',
              style: TextStyle(color: todo.isDone ? Colors.green : Colors.grey),
            ),
            SizedBox(height: 20),
            Text('${todo.description}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => BottomAddTodo(todo: todo),
          );
        },
        backgroundColor: Colors.grey[350],
        shape: CircleBorder(),
        child: Icon(Icons.edit, color: Colors.black, size: 25),
      ),
    );
  }
}
