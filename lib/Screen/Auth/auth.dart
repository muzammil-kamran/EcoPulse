import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecopulse/Screen/Auth/Loginscreen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;        // The page to show if allowed
  final String? requiredRole; // Role to check for (Admin/User)

  const AuthGuard({super.key, required this.child, this.requiredRole});

  Future<bool> _isAllowed() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    String? role = prefs.getString("Role");

    // If not logged in OR role is missing → not allowed
    if (!isLoggedIn || role == null) {
      return false;
    }

    // If a specific role is required and doesn't match → not allowed
    if (requiredRole != null && role != requiredRole) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAllowed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return child; // Allowed
        } else {
          return const Loginscreen(); // Redirect to login
        }
      },
    );
  }
}
