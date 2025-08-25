import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/User/Educational%20Content/Video%20Screen/VideoDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

class UserEducationalVideosScreen extends StatelessWidget {
  const UserEducationalVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        backgroundColor: kLightGreen,
        appBar: AppBar(
          backgroundColor: kGreen,
          title: Text(
            "Educational Videos",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("EducationalVideos")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading videos"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final videos = snapshot.data!.docs;

            if (videos.isEmpty) {
              return const Center(child: Text("No videos found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                final videoData = video.data() as Map<String, dynamic>;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoDetailScreen(videoData: videoData),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child:
                              videoData["thumbnail"] != null &&
                                  videoData["thumbnail"].toString().isNotEmpty
                              ? Image.network(
                                  videoData["thumbnail"],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 180,
                                  color: kLightGreen,
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      size: 60,
                                      color: kGreen,
                                    ),
                                  ),
                                ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                videoData["title"] ?? "Untitled Video",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kGreen,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                videoData["content"] ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black87,
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
