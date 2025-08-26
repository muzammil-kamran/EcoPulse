import 'package:ecopulse/Screen/Admin/AdminHomeScreen.dart';
import 'package:ecopulse/Screen/Admin/Eco-TravelSuggestion/Eco-trravelSuggestionScreen.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/EducationalContent.dart';
import 'package:ecopulse/Screen/Admin/Sustainable%20Challenges/challenges.dart';
import 'package:ecopulse/Screen/Admin/Categories/Category.dart';
import 'package:ecopulse/Screen/Admin/Users%20info/UsersScreen.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class Admindrawer extends StatefulWidget {
  const Admindrawer({super.key});

  @override
  State<Admindrawer> createState() => _AdmindrawerState();
}

class _AdmindrawerState extends State<Admindrawer> {
  String _name = "";
  String _role = "Admin";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("Name") ?? "Admin";
    });
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: kGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kLightGreen,
        child: Column(
          children: [
            // 🔹 Drawer Header with profile (like Userdrawer)
            Container(
              color: kGreen,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : "A",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Menu Items (same as EcoFeatureCards)
            _buildDrawerItem(Icons.dashboard, "Dashboard", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomescreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.emoji_events_rounded, "Challenges", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChallengeManagementScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.menu_book_rounded, "Educational", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EducationalContent(),
                ),
              );
            }),
            _buildDrawerItem(Icons.public_rounded, "Travel Suggestions", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageSuggestionsScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.category, "Categories", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageCategoriesScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.verified_user, "Users Information", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UsersScreen()),
              );
            }),

            const Spacer(),
            const Divider(),

            // Logout
            _buildDrawerItem(Icons.logout, "Logout", () async {
              var prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginscreen()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
