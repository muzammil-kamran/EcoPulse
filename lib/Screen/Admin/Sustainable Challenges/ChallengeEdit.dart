import 'dart:convert';
import 'dart:io' show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditChallenge extends StatefulWidget {
  final String challengeId;

  const EditChallenge({super.key, required this.challengeId});

  @override
  State<EditChallenge> createState() => _EditChallengeState();
}

class _EditChallengeState extends State<EditChallenge> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final durationController = TextEditingController();

  XFile? _image;
  String? existingImage;
  final picker = ImagePicker();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadChallengeData();
  }

  Future<void> loadChallengeData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("challenges")
          .doc(widget.challengeId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        titleController.text = data["title"] ?? "";
        descController.text = data["description"] ?? "";
        durationController.text = (data["duration"] ?? 7).toString();
        existingImage = data["image"];
      }
    } catch (e) {
      print("Error loading challenge: $e");
    }

    setState(() {
      loading = false;
    });
  }

  void pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> updateChallenge() async {
    try {
      if (titleController.text.trim().isEmpty ||
          descController.text.trim().isEmpty ||
          durationController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
        return;
      }

      // If a new image is selected, upload it
      String? imageUrl = existingImage;
      if (_image != null) {
        final uploadedUrl = await uploadImageToCloudinary(_image!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      var prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("Email");

      if (email == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection("challenges")
          .doc(widget.challengeId)
          .update({
            "title": titleController.text.trim(),
            "description": descController.text.trim(),
            "duration": int.tryParse(durationController.text.trim()) ?? 7,
            "image": imageUrl,
            "updatedAt": DateTime.now(),
            "updatedBy": email,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Challenge updated successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error updating challenge: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error updating challenge")));
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
        appBar: AppBar(title: const Center(child: Text("Edit Challenge"))),
        drawer: const Admindrawer(),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                          : (existingImage != null
                                ? Image.network(
                                    existingImage!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : const Text("No Image Selected")),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(text: "Change Image", onPressed: pickImage),

                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Update Challenge",
                      onPressed: updateChallenge,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
