import 'package:ecopulse/Screen/Admin/Eco-TravelSuggestion/Eco-TravelSuggestionAdd.dart';
import 'package:ecopulse/Screen/Admin/Eco-TravelSuggestion/Eco-TravelSuggestionEditSceen.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/User/Challenges/UserChallengesScreen.dart';
import 'package:ecopulse/Screen/User/Eco-travel%20Suggestion/UserEco-TravelSuggestionsScreen.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userdrawer extends StatefulWidget {
  const Userdrawer({super.key});

  @override
  State<Userdrawer> createState() => _UserdrawerState();
}

class _UserdrawerState extends State<Userdrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text("EcoPulse"),
          ),

          ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homescreen()),
              );
            },
          ),
          ListTile(
            title: Text("Challenges"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserChallengeScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.travel_explore),
            title: const Text("Eco travel"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EcoTravelSuggestionsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("LogOut"),

            onTap: () async {
              var pref = await SharedPreferences.getInstance();
              pref.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Loginscreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
