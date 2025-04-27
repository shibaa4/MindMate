import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GadCheckScreen extends StatefulWidget {
  const GadCheckScreen({super.key});

  @override
  _GadCheckScreenState createState() => _GadCheckScreenState();
}

class _GadCheckScreenState extends State<GadCheckScreen> {
  final List<String> questions = [
    "Feeling nervous, anxious, or on edge?",
    "Not being able to stop or control worrying?",
    "Worrying too much about different things?",
    "Trouble relaxing?",
    "Being so restless that it is hard to sit still?",
    "Becoming easily annoyed or irritable?",
    "Feeling afraid as if something awful might happen?",
  ];

  List<int> responses = List.filled(7, 0); // Store user responses

  void submitAnswers() async {
    final url = Uri.parse("http://127.0.0.1:8000/calculate_gad7"); // Change if needed

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"responses": responses}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      String mentalState = result.containsKey("mental_state") && result["mental_state"] != null
            ? result["mental_state"]
            : "Unknown Anxiety Level"; // Default fallback

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("GAD-7 Results"),
          content: Text(mentalState),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GAD-7 Anxiety Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(questions[index], style: const TextStyle(fontSize: 16)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildOption(index, 0, "Not at all"),
                            _buildOption(index, 1, "Several days"),
                            _buildOption(index, 2, "More than half the days"),
                            _buildOption(index, 3, "Nearly every day"),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: submitAnswers,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int questionIndex, int value, String label) {
    return Column(
      children: [
        Radio(
          value: value,
          groupValue: responses[questionIndex],
          onChanged: (int? newValue) {
            setState(() {
              responses[questionIndex] = newValue!;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
