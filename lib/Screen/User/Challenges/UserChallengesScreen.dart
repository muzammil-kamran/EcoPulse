import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/Challenges/CompletedChallengesScreen.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChallengeScreen extends StatefulWidget {
  const UserChallengeScreen({super.key});

  @override
  State<UserChallengeScreen> createState() => _UserChallengeScreenState();
}

class _UserChallengeScreenState extends State<UserChallengeScreen> {
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

  Future<void> joinChallenge(String challengeId) async {
    if (userEmail == null) return;

    final docId = "${userEmail}_$challengeId";

    await FirebaseFirestore.instance
        .collection("userChallenges")
        .doc(docId)
        .set({
          "challengeId": challengeId,
          "userEmail": userEmail,
          "progress": 0,
          "isCompleted": false,
          "joinedAt": DateTime.now(),
        });
  }

  Future<void> updateProgress(
    String challengeId,
    int currentProgress,
    int duration,
  ) async {
    if (userEmail == null) return;

    final docId = "${userEmail}_$challengeId";
    final newProgress = currentProgress + 1;
    final isCompleted = newProgress >= duration;

    await FirebaseFirestore.instance
        .collection("userChallenges")
        .doc(docId)
        .update({"progress": newProgress, "isCompleted": isCompleted});
  }

  void gotoCompletedChallengesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompletedChallengesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        appBar: AppBar(title: const Text("🌱 Sustainable Challenges")),
        drawer: Userdrawer(),
        body: userEmail == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 10),
                  // ✅ CustomButton for Completed Challenges
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Completed Challenges",
                      onPressed: () => gotoCompletedChallengesScreen(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("challenges")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("No challenges available"),
                          );
                        }

                        final challenges = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: challenges.length,
                          itemBuilder: (context, index) {
                            final challenge = challenges[index];
                            final challengeId = challenge.id;
                            final title = challenge['title'];
                            final description = challenge['description'];
                            final duration = challenge['duration'];
                            final imageUrl = challenge['image'] ?? "";

                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("userChallenges")
                                  .doc("${userEmail}_$challengeId")
                                  .snapshots(),
                              builder: (context, userChallengeSnapshot) {
                                final joined =
                                    userChallengeSnapshot.hasData &&
                                    userChallengeSnapshot.data!.exists;
                                final isCompleted =
                                    joined &&
                                    userChallengeSnapshot.data!['isCompleted'];

                                // Skip completed challenges
                                if (isCompleted) return const SizedBox.shrink();

                                final progress = joined
                                    ? userChallengeSnapshot.data!['progress']
                                    : 0;

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
                                        : null,
                                    title: Text(
                                      title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(description),
                                    trailing: joined
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Progress: $progress / $duration",
                                              ),
                                              ElevatedButton(
                                                onPressed: () => updateProgress(
                                                  challengeId,
                                                  progress,
                                                  duration,
                                                ),
                                                child: const Text("Update"),
                                              ),
                                            ],
                                          )
                                        : ElevatedButton(
                                            onPressed: () =>
                                                joinChallenge(challengeId),
                                            child: const Text("Join"),
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
                ],
              ),
      ),
    );
  }
}
