import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalSupportPage extends StatelessWidget {
  const ProfessionalSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> therapists = [
      {
        "name": "Dr. Ravi Sharma",
        "specialty": "Cognitive Behavioral Therapist",
        "rating": 4.9,
        "available": true,
        "phone": "+919774086099", // Include country code
      },
      {
        "name": "Mrs. Aditi Mehta",
        "specialty": "Stress & Anxiety Expert",
        "rating": 4.7,
        "available": true,
        "phone": "+918610209024",
      },
      {
        "name": "Dr. Neha Desai",
        "specialty": "Clinical Psychologist",
        "rating": 5.0,
        "available": true,
        "phone": "+917001234567",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional Support"),
      ),
      body: ListView.builder(
        itemCount: therapists.length,
        itemBuilder: (context, index) {
          final therapist = therapists[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(therapist["name"]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(therapist["specialty"]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text("${therapist["rating"]} ★"),
                    ],
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _launchWhatsApp(therapist["phone"], therapist["name"]);
                },
                child: const Text("Book"),
              ),
            ),
          );
        },
      ),
    );
  }

  void _launchWhatsApp(String phone, String name) async {
    final message =
        Uri.encodeComponent("Hi $name, I found you on the MindMate app and would like to book a consultation session.");
    final url = "https://wa.me/${phone.replaceAll('+', '')}?text=$message";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp");
    }
  }
}
