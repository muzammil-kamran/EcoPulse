import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChallengeDetailReport extends StatelessWidget {
  final String challengeId;
  final String challengeTitle;

  const ChallengeDetailReport({
    super.key,
    required this.challengeId,
    required this.challengeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("👥 $challengeTitle Participants")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("userChallenges")
            .where("challengeId", isEqualTo: challengeId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final participants = snapshot.data!.docs;

          if (participants.isEmpty) {
            return const Center(child: Text("No one joined this challenge yet"));
          }

          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              var user = participants[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user['userEmail'][0].toUpperCase()),
                ),
                title: Text(user['userEmail']),
                subtitle: Text(
                  user['isCompleted']
                      ? "✅ Completed"
                      : "⏳ In Progress (Day ${user['progress']})",
                ),
              );
            },
          );
        },
      ),
    );
  }
}

