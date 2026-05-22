import 'dart:async';
import 'package:flutter/material.dart';

class FocusProvider extends ChangeNotifier {
  int totalSeconds = 25 * 60;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (isRunning) return;

    isRunning = true;
    notifyListeners();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        totalSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        isRunning = false;
        notifyListeners();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    timer?.cancel();
    totalSeconds = 25 * 60;
    isRunning = false;
    notifyListeners();
  }

  String formatTime() {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  double get progress {
    return totalSeconds / (25 * 60);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
