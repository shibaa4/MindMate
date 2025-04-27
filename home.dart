import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'mind_check_screen.dart'; // PHQ-9 Test
import 'gad_check_screen.dart'; // GAD-7 Test
import 'resources_screen.dart';
import 'facial_analysis_screen.dart';
import 'profile.dart';
import 'goals.dart';
import 'daily_affirmations.dart';
import 'professional.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showMindcheckOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Assessment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("PHQ-9 Depression Test"),
                onTap: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MindCheckScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text("GAD-7 Anxiety Test"),
                onTap: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GadCheckScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindmate'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                // Navigate to profile screen (to be implemented)
              } else if (value == 'Logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Profile', child: Text('Profile')),
              const PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            const SizedBox(height: 20),

            // Grid for main navigation buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildDashboardButton(Icons.chat, 'Chat with AI', () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                    );
                  }),
                  _buildDashboardButton(Icons.camera, 'Facial Analysis', () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FacialAnalysisScreen()),
                    );
                  }),
                  _buildDashboardButton(Icons.edit, 'Mindcheck', () {
                    _showMindcheckOptions(context); // Now it calls the assessment selection
                  }),
                  _buildDashboardButton(Icons.library_books, "Resources", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResourcesScreen()),
                    );
                  }),
                  _buildDashboardButton(Icons.video_call, 'Professional Support', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalSupportPage(),),);
                  }),
                ],
              ),
            ),

            // Personalized Suggestions
            Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb, size: 40),
                title: const Text('Daily Affirmation'),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyAffirmationPage(),),);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.flag, size: 40),
                title: const Text('Goals & Challenges'),
                subtitle: const Text('Set and track your wellness goals!'),
               onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalsPage(userId: FirebaseAuth.instance.currentUser!.uid),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
