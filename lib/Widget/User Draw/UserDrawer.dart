import 'package:ecopulse/Screen/Admin/EnergyConservationScreen/preferences_screen.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/User/Challenges/UserChallengesScreen.dart';
import 'package:ecopulse/Screen/User/Educational%20Content/EducationalMain.dart';
import 'package:ecopulse/Screen/User/Eco-travel%20Suggestion/UserEco-TravelSuggestionsScreen.dart';
import 'package:ecopulse/Screen/User/Trackers/TrackerMain.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class Userdrawer extends StatefulWidget {
  const Userdrawer({super.key});

  @override
  State<Userdrawer> createState() => _UserdrawerState();
}

class _UserdrawerState extends State<Userdrawer> {
  String _name = "";
  String _role = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("Name") ?? "Guest User";
      _role = prefs.getString("Role") ?? "User";
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
            Container(
              color: kGreen,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : "U",
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

            // Menu Items
            _buildDrawerItem(Icons.dashboard, "Dashboard", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Homescreen()),
              );
            }),
            _buildDrawerItem(Icons.menu_book, "Educational Material", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EducationalMain(),
                ),
              );
            }),
            _buildDrawerItem(
              Icons.travel_explore,
              "Travelling Suggestions",
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EcoTravelSuggestionsScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(Icons.track_changes, "Tracker", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TrackerMain()),
              );
            }),
            _buildDrawerItem(Icons.flag, "Challenges", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserChallengeScreen(),
                ),
              );
            }),
            _buildDrawerItem(
              Icons.energy_savings_leaf,
              "Energy Conservation Tips",
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferencesScreen(),
                  ),
                );
              },
            ),

            const Spacer(),
            const Divider(),
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
