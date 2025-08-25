import 'package:ecopulse/Screen/Admin/AdminHomeScreen.dart';
import 'package:ecopulse/Screen/Auth/SignupScreen.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen>
    with SingleTickerProviderStateMixin {
  final EmailControllar = TextEditingController();
  final PassControllar = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    EmailControllar.dispose();
    PassControllar.dispose();
    super.dispose();
  }

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
            content: Text("Incorrect Email or Password"),
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
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ),
        );

        if (user['Role'] == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomescreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homescreen()),
          );
        }
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred"), backgroundColor: Colors.red),
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
      backgroundColor: kLightGreen,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Icon(Icons.eco, color: kGreen, size: 80),
                SizedBox(height: 10),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kGreen,
                  ),
                ),
                SizedBox(height: 40),

                // Email
                TextField(
                  controller: EmailControllar,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email, color: kGreen),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: kGreen),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kGreen),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kGreen.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kGreen, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password
                TextField(
                  controller: PassControllar,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock, color: kGreen),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: kGreen),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kGreen),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kGreen.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kGreen, width: 2),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Navigate to SignUp
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: NavigateToSignUp,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
