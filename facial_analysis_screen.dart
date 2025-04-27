import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FacialAnalysisScreen extends StatelessWidget {
  const FacialAnalysisScreen({super.key});

  void _launchWebView() async {
    final url = Uri.parse("http://127.0.0.1:5000/facial_analysis"); // or replace with your IP
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facial Emotion Analysis')),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchWebView,
          child: const Text("Open Facial Emotion Detector"),
        ),
      ),
    );
  }
}
