import 'package:hive_ce/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  String taskName;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  bool isDone;

  TodoModel({
    required this.taskName,
    required this.dateTime,
    this.isDone = false,
  });
}
