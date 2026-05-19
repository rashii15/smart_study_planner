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
  String get priority {
    final difference = deadline.difference(DateTime.now()).inDays;

    if (isCompleted) return "Completed";
    if (difference < 2) return "High";
    if (difference < 5) return "Medium";
    return "Low";
  }
}
