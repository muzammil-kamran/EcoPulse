import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedChallengesScreen extends StatefulWidget {
  const CompletedChallengesScreen({super.key});

  @override
  State<CompletedChallengesScreen> createState() =>
      _CompletedChallengesScreenState();
}

class _CompletedChallengesScreenState extends State<CompletedChallengesScreen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString("Email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        appBar: AppBar(title: const Text("✅ Completed Challenges")),
        drawer: Userdrawer(),
        body: userEmail == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("userChallenges")
                    .where("userEmail", isEqualTo: userEmail)
                    .where("isCompleted", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No completed challenges yet"),
                    );
                  }

                  final completedChallenges = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: completedChallenges.length,
                    itemBuilder: (context, index) {
                      final userChallenge = completedChallenges[index];
                      final challengeId = userChallenge['challengeId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("challenges")
                            .doc(challengeId)
                            .get(),
                        builder: (context, challengeSnapshot) {
                          if (challengeSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // 🔹 Handle missing/deleted challenge gracefully
                          if (!challengeSnapshot.hasData ||
                              !challengeSnapshot.data!.exists) {
                            return const SizedBox.shrink();
                          }

                          final challenge = challengeSnapshot.data!;
                          final title = challenge['title'] ?? "No Title";
                          final description =
                              challenge['description'] ?? "No Description";
                          final imageUrl = challenge['image'] ?? "";

                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(description),
                              trailing: const Text(
                                "✅ Completed",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
