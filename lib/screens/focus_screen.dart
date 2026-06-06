import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/focus_provider.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusProvider>(
      builder: (context, focusProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Focus Timer",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Use Pomodoro sessions to study with focus.",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 230,
                    width: 230,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 230,
                          width: 230,
                          child: CircularProgressIndicator(
                            value: focusProvider.progress,
                            strokeWidth: 14,
                            backgroundColor: Colors.grey.shade300,
                            color: Colors.indigo,
                          ),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              focusProvider.formatTime(),
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              focusProvider.isRunning
                                  ? "Focus Mode"
                                  : "Ready to Study",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: focusProvider.isRunning
                              ? focusProvider.pauseTimer
                              : focusProvider.startTimer,
                          icon: Icon(
                            focusProvider.isRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            focusProvider.isRunning ? "Pause" : "Start",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: focusProvider.resetTimer,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reset"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
