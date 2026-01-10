import 'package:flutter/material.dart';

class NoTodo extends StatelessWidget {
  const NoTodo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color.fromARGB(255, 224, 219, 219),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/todo.webp',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 12,),
              Text(
                '아직 할 일이 없음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8,),
              Text('할 일을 추가하고 진파르타`s Tasks에서\n할 일을 추적하세요.',
              textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
