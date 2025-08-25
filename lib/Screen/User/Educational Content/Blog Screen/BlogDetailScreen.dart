import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class BlogDetailScreen extends StatelessWidget {
  final Map<String, dynamic> blogData;

  const BlogDetailScreen({super.key, required this.blogData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreen,
      appBar: AppBar(
        backgroundColor: kGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          blogData["title"] ?? "Blog Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  blogData["image"] ??
                      "https://via.placeholder.com/400x200.png?text=Blog+Image",
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Blog Title
              Text(
                blogData["title"] ?? "Untitled Blog",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                ),
              ),
              const SizedBox(height: 10),

              // Author + Date
              Row(
                children: [
                  const Icon(Icons.person, color: kGreen, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    blogData["author"] ?? "Unknown Author",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.calendar_today, color: kGreen, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    blogData["date"] ?? "Unknown Date",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Blog Content
              Text(
                blogData["content"] ??
                    "No content available for this blog. Please check again later.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Share Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add share logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: Text(
                    "Share Blog",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
