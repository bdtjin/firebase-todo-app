import 'package:firebase_todo_app/presentation/home/model/home_view_model.dart';
import 'package:firebase_todo_app/presentation/home/ui/widgets/bottom_add_todo.dart';
import 'package:firebase_todo_app/presentation/home/ui/widgets/no_todo.dart';
import 'package:firebase_todo_app/presentation/home/ui/widgets/todo_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  void addToDo(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BottomAddTodo(
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(homeViewModelProvider); // 홈뷰모델을 관리할거야! 선언
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '진파르타`s Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      body: todos.isEmpty
          ? NoTodo()
          : TodoListView(
            ),

      // FAB 누르면 바텀에 addToDo
      floatingActionButton: FloatingActionButton(
        onPressed: () => addToDo(context),
        backgroundColor: Colors.grey[350],
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.black, size: 25),
      ),
    );
  }
}
