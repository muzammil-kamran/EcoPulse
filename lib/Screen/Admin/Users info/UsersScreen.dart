import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Admin/Users%20info/EditUserScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  Future<void> _deleteUser(String docId, BuildContext context) async {
    await FirebaseFirestore.instance.collection("user").doc(docId).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("User deleted successfully")));
  }

  void _editUser(
    BuildContext context,
    String docId,
    Map<String, dynamic> user,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditUserScreen(docId: docId, user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        backgroundColor: kLightGreen,
        appBar: AppBar(
          title: Text(
            "Manage Users",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: kGreen,
          centerTitle: true,
        ),
        drawer: const Admindrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("user").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var users = snapshot.data!.docs;

            if (users.isEmpty) {
              return Center(
                child: Text(
                  "No users found 👤",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index].data() as Map<String, dynamic>;
                var docId = users[index].id;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kGreen.withOpacity(0.2),
                      child: Text(
                        user["Name"] != null && user["Name"].isNotEmpty
                            ? user["Name"][0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user["Name"] ?? "Unknown",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "${user["Email"]}\nRole: ${user["Role"]}",
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => _editUser(context, docId, user),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteUser(docId, context),
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
    );
  }
}
