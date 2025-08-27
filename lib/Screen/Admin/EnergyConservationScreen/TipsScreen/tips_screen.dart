import 'package:ecopulse/Model/WasteReductionTracker/EnergyTips/tips_data.dart';
import 'package:ecopulse/Screen/User/Energy_Conservation_Tips/user_preferences.dart';
import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  final UserPreferences preferences;

  const TipsScreen({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    final List<String> tips = [
      ...energyTips[preferences.homeType] ?? [],
      ...energyTips[preferences.region] ?? [],
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Your Energy Tips")),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: Icon(Icons.energy_savings_leaf, color: Colors.green),
            title: Text(tips[index]),
          );
        },
      ),
    );
  }
}
