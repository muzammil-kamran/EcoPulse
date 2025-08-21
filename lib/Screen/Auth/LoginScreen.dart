import 'package:ecopulse/Screen/Admin/AdminHomeScreen.dart';
import 'package:ecopulse/Screen/Auth/SignupScreen.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final EmailControllar = TextEditingController();
  final PassControllar = TextEditingController();

  void login() async {
    try {
      final userSnapShot = await db
          .collection("user")
          .where('Email', isEqualTo: EmailControllar.text.trim())
          .where('Password', isEqualTo: PassControllar.text.trim())
          .get();
      final userDocsList = userSnapShot.docs;
      if (userDocsList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Incorect User Email or PAssword"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        var user = userDocsList[0].data() as Map<String, dynamic>;

        var prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("Email", user['Email']);
        prefs.setString("Password", user['Password']);
        prefs.setString("Role", user['Role']); // Save role

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        if (user['Role'] == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomescreen()),
          );
        } else if (user['Role'] == 'User') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homescreen()),
          );
        }
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("error occured"), backgroundColor: Colors.red),
      );
    }
  }

  void NavigateToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Signupscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Login"))),
      backgroundColor: Colors.green.shade300,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: EmailControllar,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: PassControllar,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: NavigateToSignUp,
              child: Text("Already have an Account"),
            ),

            SizedBox(height: 30),
            ElevatedButton(onPressed: login, child: Text("Login")),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
