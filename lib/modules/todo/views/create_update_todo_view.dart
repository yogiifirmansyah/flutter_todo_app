import 'package:flutter/material.dart';
import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateUpdateTodoView extends StatelessWidget {
  final TodoController todoController = Get.find<TodoController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final args = Get.arguments as Map<String, dynamic>;
    final String mode = args['mode'];

    final int? index = args['index'];
    final String? initialTitle = args['taskName'] ?? '';
    final DateTime? initialDateTime = args['dateTime'] ?? DateTime.now();

    todoController.taskEditingController.text = initialTitle ?? '';
    todoController.selectedDateTime.value = initialDateTime ?? DateTime.now();

    void submit() {
      final task = todoController.taskEditingController.text.trim();
      final date = todoController.selectedDateTime.value;

      if (todoController.taskEditingController.text.trim().isEmpty) {
        Get.snackbar(
          'Invalid Input',
          'Please enter title and select date/time',
          margin: EdgeInsets.all(8),
        );
        return;
      }

      print(mode);
      if (mode == 'update') {
        todoController.updateTask(index!, task, date);
      } else {
        todoController.addTask(task, date);
      }

      Get.back(); // Close the form
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(mode == 'update' ? 'Update Todo' : 'Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is to be done?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: todoController.taskEditingController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Due date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => GestureDetector(
                onTap: () => todoController.pickDateTime(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.grey[850] : Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'EEE, MMM d • hh:mm a',
                        ).format(todoController.selectedDateTime.value),
                        style: TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: submit,
              icon: const Icon(Icons.check),
              label: Text(mode == 'update' ? 'Update Task' : 'Create Task'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
