import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/dashboard_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../widgets/category_chips.dart';
import '../widgets/insight_card.dart';

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

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTaskSheet(),
          );
        },

        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,

        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer<TaskProvider>(
              builder: (context, provider, _) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B67F1), Color(0xFF7B83FF)],
                    ),

                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Welcome Back 👋",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Stay Organized\nStay Productive",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Consumer<TaskProvider>(
                        builder: (context, provider, _) {
                          return Text(
                            "${provider.pendingTasks} tasks pending today",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const InsightCard(),

            const SizedBox(height: 20),

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

            CategoryChips(),

            const SizedBox(height: 20),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  if (provider.filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 90,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "No Tasks Yet",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Tap the button below to add tasks",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.filteredTasks[index];

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
