import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/Admin/EnergyConservationScreen/EnergyScreen.dart';
import 'package:ecopulse/Screen/Admin/EnergyConservationScreen/TipsScreen/tips_screen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/Energy_Conservation_Tips/user_preferences.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String homeType = "Apartment";
  String region = "Hot";

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        backgroundColor: kLightGreen,
        appBar: AppBar(
          title: Text(
            "Educational Content",
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
                  MaterialPageRoute(builder: (context) => Homescreen()),
                );
              },
            ),
          ],
        ),
        drawer: const Userdrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: homeType,
                items: ["Apartment", "House"].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => homeType = val!),
                decoration: InputDecoration(labelText: "Home Type"),
              ),
              DropdownButtonFormField<String>(
                value: region,
                items: ["Hot", "Cold", "Mild"].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => region = val!),
                decoration: InputDecoration(labelText: "Climate Region"),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text("Show My Tips"),
                onPressed: () {
                  final prefs = UserPreferences(
                    homeType: homeType,
                    region: region,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TipsScreen(preferences: prefs),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
