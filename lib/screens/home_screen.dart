import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/dashboard_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Consumer<TaskProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: "Total",
                        value: provider.totalTasks.toString(),
                        icon: Icons.list_alt,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DashboardCard(
                        title: "Completed",
                        value: provider.completedTasks.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DashboardCard(
                        title: "Pending",
                        value: provider.pendingTasks.toString(),
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  if (provider.tasks.isEmpty) {
                    return const Center(child: Text("No Tasks Yet"));
                  }

                  return ListView.builder(
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.tasks[index];

                      return TaskCard(
                        task: task,
                        onDelete: () => provider.deleteTask(index),
                        onToggle: () => provider.toggleTask(index),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
