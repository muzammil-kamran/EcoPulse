import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:flutter/material.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen>
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

  void signup() async {
    final user = await db
        .collection('user')
        .where('Email', isEqualTo: EmailControllar.text)
        .get();
    final userDocsList = user.docs;

    if (userDocsList.isEmpty) {
      await db.collection('user').add({
        'Email': EmailControllar.text,
        'Password': PassControllar.text,
        'Role': 'User',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SignUp successful"),
          backgroundColor: Colors.green,
        ),
      );
      NavigateToLogin();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User already exists with this email"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void NavigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginscreen()),
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
                  "Create Account",
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

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: NavigateToLogin,
                      child: Text(
                        "Login",
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
