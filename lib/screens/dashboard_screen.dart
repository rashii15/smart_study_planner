import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/insight_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

                        Text(
                          "${provider.pendingTasks} tasks pending",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
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
                          title: "Done",
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

              const SizedBox(height: 25),

              const Text(
                "Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                "Use the Tasks tab to manage assignments and study work. Use the Focus tab for study sessions.",
                style: TextStyle(color: Colors.grey.shade600, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
