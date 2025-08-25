// lib/main.dart
import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/BlogAdd.dart';
import 'package:ecopulse/Screen/Admin/AdminHomeScreen.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/SignupScreen.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/User/OnboardingScreen%20.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: seenOnboarding ? const Homescreen() : const OnboardingScreen(),
    );
  }
}
