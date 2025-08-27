import 'package:ecopulse/Screen/Auth/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "images/Eco1.jpg",
      "title": "Welcome to EcoPulse",
      "subtitle":
          "Learn simple, daily habits that reduce your carbon footprint and save money.",
    },
    {
      "image": "images/Eco2.jpg",
      "title": "Track Your Footprint",
      "subtitle":
          "Log activities and get personalized tips to lower emissions over time.",
    },
    {
      "image": "images/eco3.jpg",
      "title": "Join the Community",
      "subtitle":
          "Share wins, join challenges, and motivate others on their green journey.",
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const Signupscreen()));
  }

  Widget _buildIndicator(int index) {
    final isActive = index == _current;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 28 : 8,
      decoration: BoxDecoration(
        color: isActive ? kGreen : kGreen.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: const Text("Skip", style: TextStyle(color: kGreen)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, index) {
                final slide = slides[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: media.width * 0.78,
                        height: media.height * 0.38,
                        decoration: BoxDecoration(
                          color: kLightGreen,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: kGreen.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            slide["image"]!,
                            fit: BoxFit.contain,
                            width: media.width * 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        slide["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        slide["subtitle"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Indicators + Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Row(
                  children: List.generate(
                    slides.length,
                    (i) => _buildIndicator(i),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 140,
                  child: (_current == slides.length - 1)
                      ? ElevatedButton(
                          onPressed: _completeOnboarding,
                          child: const Text("Get Started"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Next"),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 14),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
