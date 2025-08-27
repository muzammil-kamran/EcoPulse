import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Admin/Sustainable%20Challenges/ChallengeAdd.dart';
import 'package:ecopulse/Screen/Admin/Sustainable%20Challenges/ChallengeAdminReport.dart';
import 'package:ecopulse/Screen/Admin/Sustainable%20Challenges/ChallengeEdit.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';

class ChallengeManagementScreen extends StatelessWidget {
  const ChallengeManagementScreen({super.key});

  void deleteChallenge(String id, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("challenges")
          .doc(id)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Challenge deleted")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error deleting challenge")));
    }
  }

  void editChallenge(
    BuildContext context,
    String id,
    Map<String, dynamic> data,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditChallenge(challengeId: id)),
    );
  }

  void gotoAdminReportPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminReportPage()),
    );
  }

  void gotoAddChalenge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddChallenge()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Manage Challenges"))),
        drawer: const Admindrawer(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomButton(
                text: "Create Challenge",
                onPressed: () => gotoAddChalenge(context),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Challenge Reports",
                onPressed: () => gotoAdminReportPage(context),
              ),
              const SizedBox(height: 20),

              /// Challenge List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("challenges")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading challenges"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final challenges = snapshot.data!.docs;

                    if (challenges.isEmpty) {
                      return const Center(child: Text("No challenges found"));
                    }

                    return ListView.builder(
                      itemCount: challenges.length,
                      itemBuilder: (context, index) {
                        final challenge = challenges[index];
                        final challengeData =
                            challenge.data() as Map<String, dynamic>;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (challengeData["image"] != null &&
                                    challengeData["image"]
                                        .toString()
                                        .isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      challengeData["image"],
                                      height: 300,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  challengeData["title"] ?? "No Title",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  challengeData["description"] ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Duration: ${challengeData["duration"] ?? 0} days",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                /// Edit & Delete buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => editChallenge(
                                        context,
                                        challenge.id,
                                        challengeData,
                                      ),
                                      icon: const Icon(Icons.edit),
                                      label: const Text("Edit"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => deleteChallenge(
                                        challenge.id,
                                        context,
                                      ),
                                      icon: const Icon(Icons.delete),
                                      label: const Text("Delete"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
