import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
import 'package:get/get.dart';

class Todobinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(() => TodoController());
  }
}
