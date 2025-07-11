import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_todo_app/modules/todo/models/todo_model.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TodoController extends GetxController {
  final myBox = Hive.box('MY_BOX');
  var todoLists = <TodoModel>[].obs;

  final taskEditingController = TextEditingController();
  final selectedDateTime = DateTime.now().obs;

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();

    // Get data from box, ensure it's List<TodoModel>
    final storedData = myBox.get('TODO_LIST') as List?;
    if (storedData != null) {
      todoLists.assignAll(List<TodoModel>.from(storedData));
    }

    // Optional: Save automatically every time todoLists changes
    ever(todoLists, (callback) => saveToDatabase());

    // todoLists.addAll([
    //   TodoModel(taskName: 'Reading', dateTime: DateTime.now(), isDone: false),
    //   TodoModel(taskName: 'Learning', dateTime: DateTime.now(), isDone: false),
    //   TodoModel(taskName: 'Jogging', dateTime: DateTime.now(), isDone: false),
    // ]);
  }

  @override
  void onClose() {
    taskEditingController.dispose();
    super.onClose();
  }

  Future<void> scheduleNotification(TodoModel todo) async {
    final androidDetails = AndroidNotificationDetails(
      'todo_channel_id',
      'Todo Notifications',
      channelDescription: 'Notification for todo tasks',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('finish_task', 'Finish'),
        AndroidNotificationAction('edit_task', 'Edit'),
      ],
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final taskIndex = todoLists.indexOf(todo);

    await notificationsPlugin.zonedSchedule(
      taskIndex,
      'Task: ${todo.taskName}',
      'Due at ${DateFormat('hh:mm a').format(todo.dateTime)}',
      payload: taskIndex.toString(),
      tz.TZDateTime.from(todo.dateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  void pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
    );

    if (pickedTime == null) return;

    selectedDateTime.value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  void taskCompleted(int index) {
    final todo = todoLists[index];
    todo.isDone = !todo.isDone;

    todoLists[index] = todo;
  }

  void addTask(String newTaskName, DateTime newDateTime) {
    TodoModel todo = TodoModel(taskName: newTaskName, dateTime: newDateTime);
    todoLists.add(todo);

    todoLists.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    todoLists.refresh();

    scheduleNotification(todo);
  }

  void updateTask(int index, String newTaskName, DateTime newDateTime) {
    final updateTodo = TodoModel(
      taskName: newTaskName,
      dateTime: newDateTime,
      isDone: todoLists[index].isDone,
    );

    todoLists[index] = updateTodo;

    todoLists.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    todoLists.refresh();

    scheduleNotification(updateTodo);
  }

  void saveToDatabase() {
    myBox.put('TODO_LIST', todoLists);
  }
}
