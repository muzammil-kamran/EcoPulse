import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:flutter/material.dart';


class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final EmailControllar = TextEditingController();
  final PassControllar = TextEditingController();

  void signup() async {
    final user = await db
        .collection('user')
        .where('Email', isEqualTo: EmailControllar.text)
        .get();
    final userDocsList = user.docs;

    if (userDocsList.length == 0) {
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
          content: Text("User already exixt with this email"),
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
      appBar: AppBar(title: Center(child: Text("SignUp"))),
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
              onPressed: NavigateToLogin,
              child: Text("Already have an Account"),
            ),

            SizedBox(height: 30),
            ElevatedButton(onPressed: signup, child: Text("Sign Up")),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
    ;
  }
}
