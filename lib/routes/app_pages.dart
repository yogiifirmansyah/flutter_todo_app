import 'package:flutter_todo_app/bindings/TodoBinding.dart';
import 'package:flutter_todo_app/modules/todo/views/create_update_todo_view.dart';
import 'package:flutter_todo_app/modules/todo/views/todo_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.TODO,
      page: () => TodoView(),
      binding: Todobinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_UPDATE_TODO,
      page: () => CreateUpdateTodoView(),
      binding: Todobinding(),
    ),
  ];
}
