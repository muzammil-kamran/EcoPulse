import 'dart:convert';
import 'package:ecopulse/Screen/Admin/EducationalContent/VideoContent/VideoBlog.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVideoBlog extends StatefulWidget {
  const AddVideoBlog({super.key});

  @override
  State<AddVideoBlog> createState() => _AddVideoBlogState();
}

class _AddVideoBlogState extends State<AddVideoBlog> {
  final VideoBlogTitleController = TextEditingController();
  final VideoBlogDiscriptionController = TextEditingController();

  XFile? _video;
  final picker = ImagePicker();

  void pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _video = pickedVideo;
      });
    }
  }

  Future<String?> uploadVideoToCloudinary(XFile video) async {
    const cloudName = "dhufnlu87";
    const uploadPreset = "MyStore";

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/video/upload",
    );

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset;

    if (kIsWeb) {
      // ✅ Flutter Web: use bytes
      final videoBytes = await video.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('file', videoBytes, filename: video.name),
      );
    } else {
      // ✅ Mobile/Desktop: use path (better for big files)
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          video.path,
          filename: video.name,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonData = json.decode(resStr);
      print("Video uploaded: $jsonData");
      return jsonData['secure_url'];
    } else {
      print("Video upload failed: ${response.statusCode}");
      return null;
    }
  }

  Future<void> createVideoBlog() async {
    try {
      if (VideoBlogTitleController.text.trim().isEmpty ||
          VideoBlogDiscriptionController.text.trim().isEmpty ||
          _video == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields and upload a video")),
        );
        return;
      }

      // Upload video
      final videoUrl = await uploadVideoToCloudinary(_video!);
      if (videoUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Video upload failed")));
        return;
      }

      // Get user info
      var prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("Email");
      String? role = prefs.getString("Role");

      if (email == null || role == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
        return;
      }

      // Save video blog to Firestore
      await db.collection("EducationalVideos").add({
        "title": VideoBlogTitleController.text.trim(),
        "content": VideoBlogDiscriptionController.text.trim(),
        "video": videoUrl,
        "createdAt": DateTime.now(),
        "userEmail": email,
        "userRole": role,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video blog created successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EducationalVideosSreen()),
      );
    } catch (e) {
      print("Error creating video blog: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error creating video blog")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text("Add Video Blog"))),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: VideoBlogTitleController,
                  decoration: InputDecoration(
                    labelText: 'Blog Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: VideoBlogDiscriptionController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Blog Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Video Preview
                Container(
                  padding: EdgeInsets.all(10),
                  child: _video != null
                      ? Text("Video Selected: ${_video!.name}")
                      : Text("No Video Selected"),
                ),

                SizedBox(height: 10),
                CustomButton(text: "Upload Video", onPressed: pickVideo),
                SizedBox(height: 20),
                CustomButton(
                  text: "Create Video Blog",
                  onPressed: createVideoBlog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
