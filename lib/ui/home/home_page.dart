import 'package:firebase_todo_app/ui/home/widgets/home_no_todo.dart';
import 'package:firebase_todo_app/ui/home/widgets/to_do_entity.dart';
import 'package:firebase_todo_app/ui/home/widgets/to_do_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/firebase_todo_app/assets/images';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoEntity> todos = [];

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
      : ToDoView(), // ToDoView 페이지 index 어쩌고 추가 필요
    );
  }
}
