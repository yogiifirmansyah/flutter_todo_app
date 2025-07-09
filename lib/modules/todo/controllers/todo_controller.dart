import 'package:flutter_todo_app/modules/todo/models/todo_model.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var todoLists = <TodoModel>[].obs;

  @override
  void onInit() {
    todoLists.addAll([
      TodoModel(taskName: 'Reading', dateTime: DateTime.now(), isDone: false),
      TodoModel(taskName: 'Learning', dateTime: DateTime.now(), isDone: false),
      TodoModel(taskName: 'Jogging', dateTime: DateTime.now(), isDone: false),
    ]);

    super.onInit();
  }

  void taskCompleted(int index) {
    final todo = todoLists[index];
    todo.isDone = !todo.isDone;
    // todo.save();
    todoLists[index] = todo;
  }

  void addTask(TodoModel todo) {
    todoLists.add(todo);
  }
}
