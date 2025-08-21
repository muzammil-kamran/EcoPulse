import 'dart:convert';

import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/Blogs.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final BlogTitleController = TextEditingController();
  final BlogController = TextEditingController();

  XFile? _image;
  final picker = ImagePicker();

  void PickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> createBlog() async {
  try {
    if (BlogTitleController.text.trim().isEmpty ||
        BlogController.text.trim().isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and upload image")),
      );
      return;
    }

    // Upload image
    final imageUrl = await uploadImageToCloudnary(_image!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed")),
      );
      return;
    }

    // Get user info from SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("Email");
    String? role = prefs.getString("Role");

    if (email == null || role == null) {
      Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Loginscreen(),
                ),
              );
      return;
    }

    // Save to Firestore
    await db.collection("blogs").add({
      "title": BlogTitleController.text.trim(),
      "content": BlogController.text.trim(),
      "image": imageUrl,
      "createdAt": DateTime.now(),
      "userEmail": email,
      "userRole": role,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Blog created successfully")),
    );

    // Go to Blogs Screen
    Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogsSreen(),
                ),
              );
  } catch (e) {
    print("Error creating blog: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error creating blog")),
    );
  }
}


  Future<String?> uploadImageToCloudnary(XFile image) async {
    const cloudName = "dhufnlu87";
    const uploadPreset = "MyStore";
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final imageBytes = await image.readAsBytes();
    final Request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: image.name),
      );

    final response = await Request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonData = json.decode(resStr);
      print(jsonData);

      return jsonData['secure_url'];
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return AuthGuard(
  requiredRole: "Admin",
  child: Scaffold(
      appBar: AppBar(title: Center(child: Text("Add Education Blog"))),
      drawer: Admindrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: BlogTitleController,
              decoration: InputDecoration(
                labelText: 'Blog Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: BlogController,
              minLines: 3, // minimum height (1 line)
              maxLines: null, // grow indefinitely
              keyboardType: TextInputType.multiline,

              decoration: InputDecoration(
                labelText: 'Blog',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(10),
              child: _image != null
                  ? Image.network(_image!.path, width: 200)
                  : Text("No Image elected"),
            ),
            SizedBox(height: 10),
            CustomButton(text: "Upload Image", onPressed: PickImage),

            SizedBox(height: 20),
            CustomButton(text: "Create Blog", onPressed: createBlog),

            SizedBox(height: 20),
          ],
        ),
      ),
    )
    );
  }
}
