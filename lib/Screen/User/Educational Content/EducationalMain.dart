import 'package:ecopulse/Screen/User/Educational%20Content/Blog%20Screen/UserBlogScreen.dart';
import 'package:ecopulse/Screen/User/Educational%20Content/Video%20Screen/VideoScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class EducationalMain extends StatefulWidget {
  const EducationalMain({super.key});

  @override
  State<EducationalMain> createState() => _EducationalMainState();
}

class _EducationalMainState extends State<EducationalMain> {
  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        backgroundColor: kLightGreen,
        appBar: AppBar(
          title: Text(
            "Educational Content",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: kGreen,
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _buildContentCard(
                  context,
                  title: "Read Blogs",
                  subtitle: "Explore latest eco-friendly blogs",
                  icon: Icons.article_rounded,
                  color: kGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserBlogScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildContentCard(
                  context,
                  title: "Watch Videos",
                  subtitle: "Learn through engaging videos",
                  icon: Icons.play_circle_fill_rounded,
                  color: kGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const UserEducationalVideosScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: kLightGreen,
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: kGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
