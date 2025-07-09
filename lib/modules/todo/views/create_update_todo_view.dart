import 'package:flutter/material.dart';
import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
import 'package:flutter_todo_app/modules/todo/models/todo_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateUpdateTodoView extends StatefulWidget {
  final String? initialTitle;
  final DateTime? initialDateTime;
  // final void Function(String taskName, DateTime dateTime) onSubmit;

  const CreateUpdateTodoView({
    super.key,
    this.initialTitle,
    this.initialDateTime,
    // required this.onSubmit,
  });

  @override
  State<CreateUpdateTodoView> createState() => _CreateUpdateTodoViewState();
}

class _CreateUpdateTodoViewState extends State<CreateUpdateTodoView> {
  final TodoController todoController = Get.find<TodoController>();

  final TextEditingController taskController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }

  void _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty || _selectedDateTime == null) {
      Get.snackbar(
        'Invalid Input',
        'Please enter title and select date/time',
        margin: EdgeInsets.all(8),
      );
      return;
    }

    todoController.addTask(
      TodoModel(taskName: _titleController.text, dateTime: _selectedDateTime!),
    );
    // widget.onSubmit(_titleController.text.trim(), _selectedDateTime!);
    Get.back(); // Close the form
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTitle == null ? 'Create Todo' : 'Update Todo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDateTime,
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
                      _selectedDateTime == null
                          ? 'Select Date & Time'
                          : DateFormat(
                              'EEE, MMM d • hh:mm a',
                            ).format(_selectedDateTime!),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedDateTime == null ? Colors.grey : null,
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: Text(
                widget.initialTitle == null ? 'Create Task' : 'Update Task',
              ),
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
