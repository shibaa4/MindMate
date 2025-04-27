import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MindCheckScreen extends StatefulWidget {
  const MindCheckScreen({super.key});

  @override
  State<MindCheckScreen> createState() => _MindCheckScreenState();
}

class _MindCheckScreenState extends State<MindCheckScreen> {
  final List<String> questions = [
    "Little interest or pleasure in doing things?",
    "Feeling down, depressed, or hopeless?",
    "Trouble falling or staying asleep, or sleeping too much?",
    "Feeling tired or having little energy?",
    "Poor appetite or overeating?",
    "Feeling bad about yourself?",
    "Trouble concentrating on things?",
    "Moving or speaking very slowly?",
    "Thoughts that you would be better off dead or hurting yourself?",
  ];

  final List<int> answers = List.filled(9, 0);

  void submitResponses() async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/calculate_phq9"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"responses": answers}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      String mentalState = result.containsKey("mental_state") && result["mental_state"] != null
          ? result["mental_state"]
          : "Unknown Mental State"; // Default fallback
      _showResultDialog(mentalState);
    } else {
      _showResultDialog("Error processing results.");
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assessment Result"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mental Health Assessment")),
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
                          children: List.generate(4, (option) {
                            return Row(
                              children: [
                                Radio<int>(
                                  value: option,
                                  groupValue: answers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      answers[index] = value!;
                                    });
                                  },
                                ),
                                Text(option.toString()),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: submitResponses,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
