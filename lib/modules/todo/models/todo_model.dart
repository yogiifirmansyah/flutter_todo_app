class TodoModel {
  String taskName;
  DateTime dateTime;
  bool isDone;

  TodoModel({
    required this.taskName,
    required this.dateTime,
    this.isDone = false,
  });
}
