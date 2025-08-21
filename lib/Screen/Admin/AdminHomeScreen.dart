
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:flutter/material.dart';

class AdminHomescreen extends StatelessWidget {
  const AdminHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
  requiredRole: "Admin",
  child: Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Eco Pulse")),
      ),
      drawer: Admindrawer(),
      body: Center(
        child: Text("this is Admin Home"),
      ),
    )
    );
  }
}