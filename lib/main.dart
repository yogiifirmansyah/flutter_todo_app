import 'package:flutter/material.dart';
import 'package:flutter_todo_app/routes/app_pages.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List App',
      initialRoute: AppRoutes.TODO,
      getPages: AppPages.routes,
    );
  }
}
