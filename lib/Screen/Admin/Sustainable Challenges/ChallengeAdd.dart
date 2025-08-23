import 'dart:convert';
import 'dart:io' show File; // for mobile
import 'package:flutter/foundation.dart' show kIsWeb; // detect web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddChallenge extends StatefulWidget {
  const AddChallenge({super.key});

  @override
  State<AddChallenge> createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final durationController = TextEditingController();

  XFile? _image;
  final picker = ImagePicker();

  void pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> createChallenge() async {
    try {
      if (titleController.text.trim().isEmpty ||
          descController.text.trim().isEmpty ||
          durationController.text.trim().isEmpty ||
          _image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill all fields and upload image"),
          ),
        );
        return;
      }

      // Upload image
      final imageUrl = await uploadImageToCloudinary(_image!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
        return;
      }

      // Get user info from SharedPreferences
      var prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("Email");
      String? role = prefs.getString("Role");

      if (email == null || role == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
        return;
      }

      // Save to Firestore
      await FirebaseFirestore.instance.collection("challenges").add({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "duration": int.tryParse(durationController.text.trim()) ?? 7,
        "image": imageUrl,
        "createdAt": DateTime.now(),
        "createdBy": email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Challenge created successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error creating challenge: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error creating challenge")));
    }
  }

  Future<String?> uploadImageToCloudinary(XFile image) async {
    const cloudName = "dhufnlu87";
    const uploadPreset = "MyStore";
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final imageBytes = await image.readAsBytes();
    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: image.name),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonData = json.decode(resStr);
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
        appBar: AppBar(title: const Center(child: Text("Add Challenge"))),
        drawer: const Admindrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Challenge Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: descController,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Challenge Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duration (in days)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ FIXED cross-platform image preview
              Container(
                padding: const EdgeInsets.all(10),
                child: _image != null
                    ? (kIsWeb
                          ? Image.network(
                              _image!.path,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_image!.path),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ))
                    : const Text("No Image Selected"),
              ),
              const SizedBox(height: 10),

              CustomButton(text: "Upload Image", onPressed: pickImage),
              const SizedBox(height: 20),
              CustomButton(
                text: "Create Challenge",
                onPressed: createChallenge,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
