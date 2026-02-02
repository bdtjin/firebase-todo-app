
import 'package:firebase_todo_app/presentation/home/model/home_view_model.dart';
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
        title: Text('할 일 목록'),
      ),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('완료 여부 : ${todo.isDone ? "완료" : "미완료"}',
          style: TextStyle(color: todo.isDone ? Colors.green : Colors.grey),),
          SizedBox(height: 20),
          Text(todo.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text('${todo.description}')
        ],
      ))
    );
  }
}