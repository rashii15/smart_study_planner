import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';

class EditTaskSheet extends StatefulWidget {
  final TaskModel task;

  const EditTaskSheet({super.key, required this.task});

  @override
  State<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late TextEditingController titleController;
  late TextEditingController subjectController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    subjectController = TextEditingController(text: widget.task.subject);
    selectedDate = widget.task.deadline;
  }

  void pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void updateTask() async {
    if (titleController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty) {
      return;
    }

    final updatedTask = TaskModel(
      id: widget.task.id,
      title: titleController.text.trim(),
      subject: subjectController.text.trim(),
      deadline: selectedDate,
      isCompleted: widget.task.isCompleted,
    );

    await Provider.of<TaskProvider>(
      context,
      listen: false,
    ).updateTask(updatedTask);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Edit Task",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Task Title",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: subjectController,
            decoration: const InputDecoration(
              labelText: "Subject",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          GestureDetector(
            onTap: pickDate,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(selectedDate.toString().split(" ")[0]),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: updateTask,
              child: const Text("Update Task"),
            ),
          ),
        ],
      ),
    );
  }
}
