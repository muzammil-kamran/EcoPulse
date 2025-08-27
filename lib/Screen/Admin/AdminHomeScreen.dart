import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Admin/Eco-TravelSuggestion/Eco-trravelSuggestionScreen.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/EducationalContent.dart';
import 'package:ecopulse/Screen/Admin/Sustainable%20Challenges/challenges.dart';
import 'package:ecopulse/Screen/Admin/Users%20info/UsersScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/Built%20Feature%20Card/FeatureCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomescreen extends StatefulWidget {
  const AdminHomescreen({super.key});

  @override
  State<AdminHomescreen> createState() => _AdminHomescreenState();
}

class _AdminHomescreenState extends State<AdminHomescreen> {
  String adminName = "Admin";

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString("Name") ?? "Admin";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F6EA),
        drawer: const Admindrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E8E3E),
          elevation: 0,
          title: Text(
            "Eco Pulse - Admin",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  "Hello, $adminName 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E8E3E),
                  ),
                ),
                const SizedBox(height: 16),

                // Admin Features Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    EcoFeatureCard(
                      title: "Challenges",
                      icon: Icons.emoji_events_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChallengeManagementScreen(),
                        ),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Educational",
                      icon: Icons.menu_book_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EducationalContent()),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Travel Suggestions",
                      icon: Icons.public_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManageSuggestionsScreen(),
                        ),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Users Information",
                      icon: Icons.verified_user,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UsersScreen()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Analytics Section
                Text(
                  "Platform Insights 📊",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E8E3E),
                  ),
                ),
                const SizedBox(height: 16),

                // Progress Indicators
                _buildChallengeProgress(),
                const SizedBox(height: 16),
                _buildActiveUsers(),
                const SizedBox(height: 16),
                _buildJoinedUsers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Progress Indicator for Challenges (all users combined)
  Widget _buildChallengeProgress() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("userChallenges")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return _infoCard("No challenges available yet 🌱");
        }

        double totalProgress = 0;
        int count = 0;
        int completed = 0;

        for (var doc in docs) {
          double progress = (doc["progress"] ?? 0).toDouble();
          if (progress > 1) progress = progress / 100;
          if (progress < 0) progress = 0;
          totalProgress += progress;
          count++;

          if (doc["isCompleted"] == true) {
            completed++;
          }
        }

        double avgProgress = count > 0 ? totalProgress / count : 0;

        return _progressCard(
          title: "Overall Challenge Progress",
          value: avgProgress,
          subtitle: "$completed challenges fully completed",
        );
      },
    );
  }

  /// 🔹 Total Active Users
  Widget _buildActiveUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("user")
          .where("Role", isEqualTo: "User")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        int userCount = snapshot.data!.docs.length;

        return _progressCard(
          title: "Active Users",
          value: 1.0, // Always 100% since it's count
          subtitle: "$userCount users registered",
        );
      },
    );
  }

  /// 🔹 Users joined challenges
  Widget _buildJoinedUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("userChallenges")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var userEmails = snapshot.data!.docs
            .map((doc) => doc["userEmail"])
            .toSet();

        return _progressCard(
          title: "Users in Challenges",
          value: 1.0, // Always 100% since it's count
          subtitle: "${userEmails.length} users joined challenges",
        );
      },
    );
  }

  /// 🔹 Helper for Info Card
  Widget _infoCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
      ),
    );
  }

  /// 🔹 Helper for Progress Card
  Widget _progressCard({
    required String title,
    required double value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: const Color(0xFF1E8E3E),
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1E8E3E),
            backgroundColor: Colors.green.shade100,
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }
}
