import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Admin/Sustainable%20Challenges/ChallengeDetailedReport.dart';
import 'package:flutter/material.dart';

class AdminReportPage extends StatelessWidget {
  const AdminReportPage({super.key});

  Future<Map<String, dynamic>> getChallengeStats(String challengeId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("userChallenges")
        .where("challengeId", isEqualTo: challengeId)
        .get();

    int totalJoined = snapshot.docs.length;
    int totalCompleted = snapshot.docs
        .where((doc) => doc['isCompleted'] == true)
        .length;

    return {"joined": totalJoined, "completed": totalCompleted};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📊 Admin Report")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("challenges")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final challenges = snapshot.data!.docs;

          if (challenges.isEmpty) {
            return const Center(child: Text("No challenges found"));
          }

          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              var challenge = challenges[index];
              String challengeId = challenge.id;
              String title = challenge['title'];

              return FutureBuilder<Map<String, dynamic>>(
                future: getChallengeStats(challengeId),
                builder: (context, statsSnapshot) {
                  if (!statsSnapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  var stats = statsSnapshot.data!;
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Joined: ${stats['joined']} | Completed: ${stats['completed']}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChallengeDetailReport(
                                challengeId: challengeId,
                                challengeTitle: title,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
