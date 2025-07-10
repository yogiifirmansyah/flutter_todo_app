import 'package:flutter/material.dart';
import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
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
          Get.toNamed('/create-update-todo', arguments: {'mode': 'create'});
          // Get.to(
          //   () => CreateUpdateTodoView(
          //     onSubmit: (name, time) {
          //       // Save to Hive or controller
          //       todoController.addTask(name, time);
          //     },
          //   ),
          // );
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
                Get.toNamed(
                  '/create-update-todo',
                  arguments: {
                    'mode': 'update',
                    'index': index,
                    'taskName': todo.taskName,
                    'dateTime': todo.dateTime,
                  },
                );
                // Get.to(
                //   () => CreateUpdateTodoView(
                //     initialTitle: todo.taskName,
                //     initialDateTime: todo.dateTime,
                //     onSubmit: (name, time) {
                //       // Update logic here
                //       todoController.updateTask(index, name, time);
                //     },
                //   ),
                // );
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
