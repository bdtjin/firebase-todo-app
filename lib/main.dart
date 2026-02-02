import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo_app/core/router.dart';
import 'package:firebase_todo_app/firebase_options.dart';
import 'package:firebase_todo_app/presentation/home/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GoRouter를 사용하여 MaterialApp에 router를 전달
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // home: HomePage(title: '진파르타`s Tasks',),
    );
  }
}
