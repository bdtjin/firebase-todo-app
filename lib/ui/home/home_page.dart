import 'package:firebase_todo_app/ui/home/widgets/home_bottom.dart';
import 'package:firebase_todo_app/ui/home/widgets/home_no_todo.dart';
import 'package:firebase_todo_app/ui/home/widgets/to_do_entity.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoEntity> todos = [];

  void addToDo(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => AddToDoBottom(
        deliver: (title, description, isFavorite, isDone) {
          setState(() {
            todos.add(ToDoEntity(
              title: title, 
              description: description, 
              isFavorite: isFavorite, 
              isDone: isDone),);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          : NoTodo(),

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
