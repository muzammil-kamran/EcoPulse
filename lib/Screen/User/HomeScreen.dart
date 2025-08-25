import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/Challenges/UserChallengesScreen.dart';
import 'package:ecopulse/Screen/User/Community%20Forum/ComunityForum.dart';
import 'package:ecopulse/Screen/User/Eco-travel%20Suggestion/UserEco-TravelSuggestionsScreen.dart';
import 'package:ecopulse/Screen/User/Educational%20Content/EducationalMain.dart';
import 'package:ecopulse/Screen/User/Trackers/TrackerMain.dart';
import 'package:ecopulse/Widget/Built%20Feature%20Card/FeatureCard.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Replace with your actual imports for other screens

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;
  String userName = "User"; // Get from SharedPreferences later
  double weeklyProgress = 0.6; // Example, fetch from Firestore

  // Navigation Screens
  final List<Widget> _screens = [
    const SizedBox(), // Home is index 0
    TrackerMain(),
    ForumScreem(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => TrackerMain()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ForumScreem()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F6EA), // light green
        drawer: const Userdrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E8E3E),
          elevation: 0,
          title: Text(
            "Eco Pulse",
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
                  "Hello, $userName 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E8E3E),
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Access Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    EcoFeatureCard(
                      title: "Tracker",
                      icon: Icons.show_chart_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TrackerMain()),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Educational",
                      icon: Icons.video_library_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EducationalMain()),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Travel",
                      icon: Icons.public_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EcoTravelSuggestionsScreen(),
                        ),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Challenges",
                      icon: Icons.emoji_events_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserChallengeScreen(),
                        ),
                      ),
                    ),
                    EcoFeatureCard(
                      title: "Community",
                      icon: Icons.people_alt_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ForumScreem()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Progress Banner
                Container(
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
                        "Your Sustainability Progress 🌱",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: const Color(0xFF1E8E3E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: weeklyProgress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFF1E8E3E),
                        backgroundColor: Colors.green.shade100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${(weeklyProgress * 100).toStringAsFixed(0)}% complete this week",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1E8E3E),
          unselectedItemColor: Colors.grey,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded),
              label: "Tracker",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded),
              label: "Forum",
            ),
          ],
        ),
      ),
    );
  }
}
