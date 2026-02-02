import 'package:firebase_todo_app/presentation/home/model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomAddTodo extends ConsumerStatefulWidget {
  // final Function(String, String, bool, bool) deliver;
  // const BottomAddTodo({required this.deliver});

  @override
  ConsumerState<BottomAddTodo> createState() => _AddToDoBottomState();
}

class _AddToDoBottomState extends ConsumerState<BottomAddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // 3. 상태 변수 (UI 변화)
  bool isFavorite = false;
  bool isDescription = false;
  bool canSave = false;

  // 4. 저장 후 넘겨야할 값들 (함수)
  void saveToDo() {
    // Riverpod을 통해 HomeViewModel의 notifier 가져오기
    final vm = ref.read(homeViewModelProvider.notifier);
    if (titleController.text.isEmpty) return;
    // ToDoEntity 객체를 만들기
    vm.addToDo(
      title: titleController.text,
      description: descriptionController.text,
      isFavorite: isFavorite,
    );
    Navigator.of(context).pop();
  }

  // 초기 위젯 UI
  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      setState(() {
        canSave = titleController.text.isNotEmpty;
      });
    });
  }

  // 위젯 사라지고 실행
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. 키보드 작업 + TextField
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            maxLines: 1,
            autofocus: true,
            style: TextStyle(fontSize: 16),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "새 할 일",
              border: InputBorder.none, // 선 없애기
            ),
            onSubmitted: (value) {
              saveToDo();
            },
          ),

          TextField(
            controller: descriptionController,
            maxLines: null,
            autofocus: true,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "세부정보 추가",
              border: InputBorder.none,
            ),
          ),

          // 2. 즐찾,저장 버튼
          Row(
            children: [
              IconButton(
                // 즐겨찾기
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : null,
                ),
              ),
              Spacer(),

              TextButton(
                // 저장버튼
                onPressed: titleController.text.isNotEmpty
                    ? saveToDo // 내용이 있으면 저장 함수 사용
                    : null, // 내용 없으면 함수 사용 X
                child: Text(
                  "저장",
                  style: TextStyle(
                    fontSize: 14,
                    color: canSave ? Colors.blue : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
