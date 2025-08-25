import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/Educational%20Content/Blog%20Screen/BlogDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class UserBlogScreen extends StatelessWidget {
  const UserBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        backgroundColor: kLightGreen,
        appBar: AppBar(
          backgroundColor: kGreen,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Eco Blogs",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("blogs")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading blogs"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final blogs = snapshot.data!.docs;

            if (blogs.isEmpty) {
              return Center(
                child: Text(
                  "No blogs available 🌱",
                  style: GoogleFonts.poppins(fontSize: 16, color: kGreen),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];
                final blogData = blog.data() as Map<String, dynamic>;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BlogDetailScreen(blogData: blogData),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Blog Image
                        if (blogData["image"] != null &&
                            blogData["image"].toString().isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              blogData["image"],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                blogData["title"] ?? "No Title",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: kGreen,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Content preview
                              Text(
                                blogData["content"] ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Read More button
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlogDetailScreen(
                                          blogData: blogData,
                                        ),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: kGreen,
                                  ),
                                  child: Text(
                                    "Read More →",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: kGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
