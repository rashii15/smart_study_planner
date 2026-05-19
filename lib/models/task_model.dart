class TaskModel {
  String title;
  String subject;
  DateTime deadline;
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.subject,
    required this.deadline,
    this.isCompleted = false,
  });
}
