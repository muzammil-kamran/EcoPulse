import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/Blogs.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/VideoContent/VideoBlog.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';

class EducationalContent extends StatelessWidget {
  const EducationalContent({super.key});

  void goToVideos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EducationalVideosSreen()),
    );
  }

  void goToBlogs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BlogsSreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Educational Content"))),
        drawer: const Admindrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Educational Videos",
                onPressed: () => goToVideos(context),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Educational Blogs",
                onPressed: () => goToBlogs(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
