import 'package:flutter/material.dart';
import 'package:flutter_todo_app/modules/todo/models/todo_model.dart';
import 'package:flutter_todo_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<TodoModel>(TodoModelAdapter());
  await Hive.openBox('MY_BOX');
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
