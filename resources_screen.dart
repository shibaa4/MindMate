import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  // Function to open links
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not open $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mental Health Resources")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Explore resources to improve your mental well-being",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),

          // 📚 Recommended Books
          _buildResourceCard(
            title: "📚 Recommended Books",
            description: "Explore books that promote mental well-being.",
            onTap: () => _openLink("https://www.goodreads.com/shelf/show/mental-health"),
          ),

          // 🎥 Helpful Videos
          _buildResourceCard(
            title: "🎥 Helpful Videos",
            description: "Watch insightful videos on mental wellness.",
            onTap: () => _openLink("https://www.youtube.com/results?search_query=mental+health"),
          ),

          // 🎧 Podcasts & Talks
          _buildResourceCard(
            title: "🎧 Podcasts & Talks",
            description: "Listen to expert podcasts on mental health topics.",
            onTap: () => _openLink("https://www.spotify.com/podcasts/mental-health/"),
          ),

          // 🏋️‍♂️ Mindfulness & Meditation Apps
          _buildResourceCard(
            title: "🏋️‍♂️ Mindfulness & Meditation Apps",
            description: "Find apps for mindfulness and stress relief.",
            onTap: () => _openLink("https://www.headspace.com/"),
          ),

          // 💡 Self-Care Tips
          _buildResourceCard(
            title: "💡 Self-Care Tips",
            description: "Practical ways to take care of your mental health.",
            onTap: () => _openLink("https://www.mentalhealth.org.uk/explore-mental-health/self-care"),
          ),
           // 🆕 **Newly Added Links**  
          _buildResourceCard(
            title: "📝 Mental Health Screening",
            description: "Take free mental health screenings online.",
            onTap: () => _openLink("https://screening.mhanational.org/"),
          ),

          _buildResourceCard(
            title: "🛠 Cognitive Behavioral Therapy (CBT) Tools",
            description: "Self-help CBT resources for mental well-being.",
            onTap: () => _openLink("https://www.getselfhelp.co.uk/"),
          ),

          _buildResourceCard(
            title: "💬 Online Therapy & Counseling",
            description: "Find professional therapy online.",
            onTap: () => _openLink("https://www.betterhelp.com/"),
          ),

          _buildResourceCard(
            title: "❤️ Support Groups & Communities",
            description: "Connect with others facing similar challenges.",
            onTap: () => _openLink("https://www.7cups.com/"),
          ),

          _buildResourceCard(
            title: "📖 Mental Health Articles & Research",
            description: "Read evidence-based articles on mental health.",
            onTap: () => _openLink("https://www.psychologytoday.com/"),
          ),
        ],
      ),
    );
  }

  // Widget for resource cards
  Widget _buildResourceCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.link, size: 40, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
        onTap: onTap,
      ),
    );
  }
}
