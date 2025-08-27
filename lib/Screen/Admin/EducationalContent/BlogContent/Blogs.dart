import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/BlogAdd.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/ShowBlog.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';

class BlogsSreen extends StatelessWidget {
  const BlogsSreen({super.key});

  void GotoAddBlog(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddBlog()));
  }

  void deleteBlog(String docId) {
    FirebaseFirestore.instance.collection("blogs").doc(docId).delete();
  }

  void editBlog(BuildContext context, DocumentSnapshot blogDoc) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddBlog(
    //       docID: blogDoc.id,
    //       blog: blogDoc.data() as Map<String, dynamic>,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Education Blogs"))),
        drawer: const Admindrawer(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomButton(
                text: "Add New Blog",
                onPressed: () => GotoAddBlog(context),
              ),
              const SizedBox(height: 20),

              /// Blog List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
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
                      return const Center(child: Text("No blogs found"));
                    }

                    return ListView.builder(
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
                                    BlogDetail(blogData: blogData),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (blogData["image"] != null &&
                                      blogData["image"].toString().isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        blogData["image"],
                                        height: 300,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    blogData["title"] ?? "No Title",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    blogData["content"] ?? "",
                                    maxLines: 2, // just preview
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),

                                  /// keep edit & delete buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            editBlog(context, blog),
                                        icon: const Icon(Icons.edit),
                                        label: const Text("Edit"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => deleteBlog(blog.id),
                                        icon: const Icon(Icons.delete),
                                        label: const Text("Delete"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
}
