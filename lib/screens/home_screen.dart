import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        title: const Text(
          "Smart Study Planner",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTaskSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: provider.tasks.isEmpty
            ? const Center(
                child: Text(
                  "No Tasks Yet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                itemCount: provider.tasks.length,

                itemBuilder: (context, index) {
                  final task = provider.tasks[index];

                  return TaskCard(
                    task: task,
                    onDelete: () {
                      provider.deleteTask(index);
                    },
                    onToggle: () {
                      provider.toggleTask(index);
                    },
                  );
                },
              ),
      ),
    );
  }
}
