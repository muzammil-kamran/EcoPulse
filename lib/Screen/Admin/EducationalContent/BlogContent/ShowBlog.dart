import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:flutter/material.dart';

class BlogDetail extends StatelessWidget {
  final Map<String, dynamic> blogData;

  const BlogDetail({super.key, required this.blogData});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: Text(blogData["title"] ?? "Blog Detail")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blogData["image"] != null &&
                  blogData["image"].toString().isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    blogData["image"],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                blogData["title"] ?? "No Title",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                blogData["content"] ?? "No Content",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
