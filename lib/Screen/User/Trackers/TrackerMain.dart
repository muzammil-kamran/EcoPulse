import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/User/Trackers/Carbon%20FootPrint%20Tracker/footprint%20.dart';
import 'package:ecopulse/Screen/User/Trackers/Waste_Reduction_Tracker/WasteReductionTracker.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class TrackerMain extends StatefulWidget {
  const TrackerMain({super.key});

  @override
  State<TrackerMain> createState() => _TrackerMainState();
}

class _TrackerMainState extends State<TrackerMain> {
  int _selectedIndex = 1; // Default on Tracker tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pop(context); // Go back to Home
    } else if (index == 2) {
      Navigator.pushNamed(context, "/forum"); // Adjust route name
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        backgroundColor: kLightGreen,
        drawer: const Userdrawer(),
        appBar: AppBar(
          title: Text(
            "Trackers",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: kGreen,
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Navigate to Home Screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Homescreen()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _buildContentCard(
                  context,
                  title: "Carbon Footprint",
                  subtitle: "Track your CO₂ emissions",
                  icon: Icons.eco_rounded,
                  color: kGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TrackerScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildContentCard(
                  context,
                  title: "Waste Management ",
                  subtitle: "Monitor your Waste",
                  icon: Icons.recycling,
                  color: kGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WasteReductionTracker(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: kGreen,
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

  Widget _buildContentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: kLightGreen,
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: kGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
