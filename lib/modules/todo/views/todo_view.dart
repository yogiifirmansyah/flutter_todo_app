import 'package:flutter/material.dart';
import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
import 'package:flutter_todo_app/modules/todo/views/create_update_todo_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodoView extends StatelessWidget {
  final TodoController todoController = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List App'),
        leading: Icon(Icons.task_alt),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/create-update-todo');
        },
        child: Icon(Icons.add_task),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: todoController.todoLists.length,
          itemBuilder: (context, index) {
            final todo = todoController.todoLists[index];

            return GestureDetector(
              onTap: () {
                Get.to(
                  () => CreateUpdateTodoView(
                    initialTitle: todo.taskName,
                    initialDateTime: todo.dateTime,
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.taskName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          Text(
                            DateFormat(
                              'EEE, MMM d • hh:mm a',
                            ).format(todo.dateTime),
                          ),
                        ],
                      ),
                      Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          todoController.taskCompleted(index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
