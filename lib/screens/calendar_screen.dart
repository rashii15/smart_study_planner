import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  bool isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isUpcoming(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now);
  }

  bool isOverdue(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            final todayTasks = provider.tasks
                .where((task) => isToday(task.deadline))
                .toList();

            final overdueTasks = provider.tasks
                .where((task) => isOverdue(task.deadline) && !task.isCompleted)
                .toList();

            final upcomingTasks = provider.tasks
                .where(
                  (task) =>
                      isUpcoming(task.deadline) && !isToday(task.deadline),
                )
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const Text(
                    "Study Calendar",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "View your study deadlines by date.",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 25),

                  _Section(
                    title: "Today",
                    tasks: todayTasks,
                    emptyMessage: "No tasks due today",
                  ),

                  const SizedBox(height: 20),

                  _Section(
                    title: "Overdue",
                    tasks: overdueTasks,
                    emptyMessage: "No overdue tasks",
                  ),

                  const SizedBox(height: 20),

                  _Section(
                    title: "Upcoming",
                    tasks: upcomingTasks,
                    emptyMessage: "No upcoming tasks",
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List tasks;
  final String emptyMessage;

  const _Section({
    required this.title,
    required this.tasks,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        if (tasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          ...tasks.map((task) {
            final index = provider.tasks.indexOf(task);

            return TaskCard(
              task: task,
              onDelete: () => provider.deleteTask(index),
              onToggle: () => provider.toggleTask(index),
            );
          }),
      ],
    );
  }
}
