import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/Challenges/CompletedChallengesScreen.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
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
          "lastUpdated": null, // track when user last updated
        });
  }

  Future<void> updateProgress(
    String challengeId,
    int currentProgress,
    int duration,
  ) async {
    if (userEmail == null) return;

    final docId = "${userEmail}_$challengeId";
    final docRef = FirebaseFirestore.instance
        .collection("userChallenges")
        .doc(docId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final lastUpdated = data["lastUpdated"] != null
        ? (data["lastUpdated"] as Timestamp).toDate()
        : null;

    final now = DateTime.now();

    // ✅ Restrict updates to once per day
    if (lastUpdated != null &&
        lastUpdated.year == now.year &&
        lastUpdated.month == now.month &&
        lastUpdated.day == now.day) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only update once per day 🌱")),
      );
      return;
    }

    final newProgress = currentProgress + 1;
    final isCompleted = newProgress >= duration;

    await docRef.update({
      "progress": newProgress,
      "isCompleted": isCompleted,
      "lastUpdated": now,
    });
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
        appBar: AppBar(
          title: const Text("🌱 Sustainable Challenges"),
          backgroundColor: const Color(0xFF1E8E3E),
          actions: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Homescreen()),
                );
              },
            ),
          ],
        ),
        drawer: Userdrawer(),
        body: userEmail == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 10),
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

                                // ------------------ JOIN CHALLENGE CARD ------------------
                                if (!joined) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (imageUrl.isNotEmpty)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                imageUrl,
                                                height: 200,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          const SizedBox(height: 10),
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Duration: ${duration ?? 0} days",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  joinChallenge(challengeId),
                                              icon: const Icon(
                                                Icons.playlist_add_check,
                                              ),
                                              label: const Text("Join"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                // ------------------ IN-PROGRESS CHALLENGE CARD ------------------
                                final data =
                                    userChallengeSnapshot.data!.data() as Map;
                                final isCompleted =
                                    data["isCompleted"] ?? false;
                                final progress = data["progress"] ?? 0;
                                final lastUpdated = data["lastUpdated"] != null
                                    ? (data["lastUpdated"] as Timestamp)
                                          .toDate()
                                    : null;

                                if (isCompleted) {
                                  return const SizedBox.shrink();
                                }

                                final now = DateTime.now();
                                final updatedToday =
                                    lastUpdated != null &&
                                    lastUpdated.year == now.year &&
                                    lastUpdated.month == now.month &&
                                    lastUpdated.day == now.day;

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (imageUrl.isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              imageUrl,
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        const SizedBox(height: 10),
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Duration: $duration days",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Progress: $progress / $duration",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: updatedToday
                                                ? null
                                                : () => updateProgress(
                                                    challengeId,
                                                    progress,
                                                    duration,
                                                  ),
                                            icon: const Icon(Icons.update),
                                            label: const Text("Update"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
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
