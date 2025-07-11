import 'package:flutter/material.dart';
import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
import 'package:flutter_todo_app/modules/todo/models/todo_model.dart';
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
        // Step 1: Group the todos by date
        Map<String, List<TodoModel>> groupedTodos = {};

        for (var todo in todoController.todoLists) {
          String dateKey = DateFormat('yyyy-MM-dd').format(todo.dateTime);
          // print(dateKey);
          if (!groupedTodos.containsKey(dateKey)) {
            groupedTodos[dateKey] = [];
          }
          groupedTodos[dateKey]!.add(todo);
        }

        // Step 2: Sort the groups and tasks
        final sortedKeys = groupedTodos.keys.toList()
          ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

        // print(sortedKeys);

        return ListView(
          children: sortedKeys.map((dateKey) {
            final tasks = groupedTodos[dateKey]!
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            final parsed = DateTime.parse(dateKey);
            final taskDate = DateTime(parsed.year, parsed.month, parsed.day);

            final overDue = taskDate.isBefore(today);
            final diff = taskDate.difference(today).inDays;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                  child: Text(
                    diff == 0
                        ? 'Today'
                        : diff == 1
                        ? 'Tomorrow'
                        : DateFormat(
                            'EEEE, MMM d',
                          ).format(DateTime.parse(dateKey)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: overDue ? Colors.red : Colors.grey[700],
                    ),
                  ),
                ),
                // Task cards
                ...tasks.map((todo) {
                  final index = todoController.todoLists.indexOf(todo);

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
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
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
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('hh:mm a').format(todo.dateTime),
                                  style: TextStyle(
                                    color: overDue
                                        ? Colors.red[400]
                                        : Colors.grey[600],
                                  ),
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
                }).toList(),
              ],
            );
          }).toList(),
        );
      }),
    );
  }
}
