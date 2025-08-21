import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
  requiredRole: "User",
  child: Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Eco Pulse")),
      ),
      drawer: Userdrawer(),
    )
    );
  }
}