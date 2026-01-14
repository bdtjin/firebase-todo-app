import 'package:firebase_todo_app/ui/home/home_view_model.dart';
import 'package:firebase_todo_app/ui/home/widgets/bottom_add_todo.dart';
import 'package:firebase_todo_app/ui/home/widgets/no_todo.dart';
import 'package:firebase_todo_app/data/model/todo_entity.dart';
import 'package:firebase_todo_app/ui/home/widgets/todo_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<ToDoEntity> todos = [];

  void addToDo(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BottomAddTodo(
        deliver: (title, description, isFavorite, isDone) {
          setState(() {
            todos.add(
              ToDoEntity(
                id: "",
                title: title,
                description: description,
                isFavorite: isFavorite,
                isDone: isDone,
              ),
            );
          });
        },
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
          : TodoListView( // TodoListView 2-3. 데이터, 생성자 만들고 전달
          todo: todos,
          onToggleFavorite: (index) {
            setState(() {
              todos [index] = todos[index].copyWith(isFavorite: !todos[index].isFavorite);
            });
          },
          onToggleleDone: (index) {
            setState(() {
              todos[index] = todos[index].copyWith(isDone: !todos[index].isDone);
            });
          },
          onToggleDelete: (index) {
            print('삭제 클릭');
            // ViewModel 구현 완료 후 UI에 적용되도록 구현 !!
             ref.read(homeViewModelProvider.notifier).deleteToDo(id: todos[index].id);
          },
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
