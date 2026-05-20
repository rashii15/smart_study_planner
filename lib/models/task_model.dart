class TaskModel {
  String? id;
  String title;
  String subject;
  DateTime deadline;
  bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    this.isCompleted = false,
  });

  String get priority {
    final difference = deadline.difference(DateTime.now()).inDays;

    if (isCompleted) return "Completed";
    if (difference < 0) return "Overdue";
    if (difference < 2) return "High";
    if (difference < 5) return "Medium";
    return "Low";
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'],
      subject: map['subject'],
      deadline: DateTime.parse(map['deadline']),
      isCompleted: map['isCompleted'],
    );
  }
}
