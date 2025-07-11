import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_todo_app/modules/todo/controllers/todo_controller.dart';
import 'package:flutter_todo_app/modules/todo/models/todo_model.dart';
import 'package:flutter_todo_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeTimeZones();

  // https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  setLocalLocation(getLocation('Asia/Jakarta'));

  const androidSettings = AndroidInitializationSettings('ic_launcher');
  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      final actionId = response.actionId;

      print('test');
      print(payload);
      print(actionId);

      if (actionId == 'finish_task') {
        final taskId = int.parse(payload!); // assuming payload is task index
        Get.find<TodoController>().taskCompleted(taskId);
      } else if (actionId == 'edit_task') {
        final taskId = int.parse(payload!);
        final task = Get.find<TodoController>().todoLists[taskId];
        Get.toNamed(
          '/create-update-todo',
          arguments: {
            'mode': 'update',
            'index': taskId,
            'taskName': task.taskName,
            'dateTime': task.dateTime,
          },
        );
      }
    },
  );

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
