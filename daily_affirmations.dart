import 'package:flutter/material.dart';
import 'dart:math';

class DailyAffirmationPage extends StatefulWidget {
  const DailyAffirmationPage({super.key});

  @override
  _DailyAffirmationPageState createState() => _DailyAffirmationPageState();
}

class _DailyAffirmationPageState extends State<DailyAffirmationPage> {
  final List<String> allAffirmations = [
    "You are enough.",
    "Your feelings are valid.",
    "You are capable of amazing things.",
    "Today is full of possibilities.",
    "You deserve love and happiness.",
    "You are resilient and strong.",
    "Progress, not perfection.",
    "Breathe. You’ve got this.",
    "You are growing every day.",
    "Small steps matter."
    // Add more affirmations here
  ];

  late List<String> todayAffirmations;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateTodayAffirmations();
  }

  void _generateTodayAffirmations() {
    final now = DateTime.now();
    final random = Random(now.day + now.month + now.year); // Changes daily
    todayAffirmations = List.generate(5, (_) {
      return allAffirmations[random.nextInt(allAffirmations.length)];
    });
  }

  void _nextAffirmation() {
    setState(() {
      currentIndex = (currentIndex + 1) % todayAffirmations.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Affirmations")),
      body: GestureDetector(
        onTap: _nextAffirmation,
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Colors.lightBlue[50],
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                todayAffirmations[currentIndex],
                key: ValueKey<String>(todayAffirmations[currentIndex]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
