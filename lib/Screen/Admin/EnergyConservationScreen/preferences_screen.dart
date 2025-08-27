import 'package:ecopulse/Screen/Admin/EnergyConservationScreen/TipsScreen/tips_screen.dart';
import 'package:ecopulse/Screen/User/Energy_Conservation_Tips/user_preferences.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Your Preferences')),
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
    );
  }
}
