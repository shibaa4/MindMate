import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? profileImageUrl;
  int? mentalScore;
  String? mentalRank;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          name = data['name'];
          email = data['email'];
          profileImageUrl = data['profileImage'];
          mentalScore = data['mentalHealthScore'];
          mentalRank = data['mentalHealthRank'];
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (profileImageUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl!),
                      radius: 50,
                    )
                  else
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 40),
                    ),
                  const SizedBox(height: 20),
                  Text(name ?? "No Name", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(email ?? "No Email", style: const TextStyle(fontSize: 16)),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mental Health Score:", style: TextStyle(fontSize: 16)),
                      Text(mentalScore?.toString() ?? "-", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mental Health Rank:", style: TextStyle(fontSize: 16)),
                      Text(mentalRank ?? "-", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
