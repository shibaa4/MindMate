import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoalsPage extends StatefulWidget {
  final String userId;
  GoalsPage({required this.userId});

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<String> goals = [];
  List<String> completedGoals = [];
  int points = 0;

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  // Fetch the goals based on the user's scores
  Future<void> _fetchGoals() async {
  final phq9Score = 10;
  final gad7Score = 7;

  final url = Uri.parse('http://127.0.0.1:8000/generate_goals');
  final response = await http.post(url,
    body: json.encode({
      "email": widget.userId,
      "phq9_score": phq9Score,
      "gad7_score": gad7Score,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  print('GOALS RESPONSE: ${response.body}');


  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      goals = List<String>.from(data['goals']);
    });
  } else {
    print('Failed to load goals: ${response.body}');
  }
}

  // Update completed goals in the backend
 Future<void> _updateCompletedGoals() async {
  final url = Uri.parse('http://127.0.0.1:8000/update_user_goals');
  final response = await http.post(url,
    body: json.encode({
      'user_id': widget.userId,
      'completed_goals': completedGoals,
    }),
    headers: {
      'Content-Type': 'application/json',
    });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      points = data['points'];
    });
  } else {
    print('Failed to update goals: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goals & Challenges')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complete the following tasks to improve your mental health:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(goals[index]),
                    value: completedGoals.contains(goals[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          completedGoals.add(goals[index]);
                        } else {
                          completedGoals.remove(goals[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _updateCompletedGoals,
              child: Text('Update Progress'),
            ),
            SizedBox(height: 20),
            Text('Your Points: $points', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
