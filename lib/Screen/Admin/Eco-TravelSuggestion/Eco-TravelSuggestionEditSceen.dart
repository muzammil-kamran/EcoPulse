import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File; // only for mobile
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

class EcoTravelSuggestionsEditScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> suggestion;

  const EcoTravelSuggestionsEditScreen({
    super.key,
    required this.docId,
    required this.suggestion,
  });

  @override
  State<EcoTravelSuggestionsEditScreen> createState() =>
      _EcoTravelSuggestionsEditScreenState();
}

class _EcoTravelSuggestionsEditScreenState
    extends State<EcoTravelSuggestionsEditScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();

  XFile? _image;
  Uint8List? _webImage; // for web image preview
  String? existingImage;
  String? selectedCategoryId;
  String? selectedCategoryName;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Pre-fill data from Firestore doc
    titleController.text = widget.suggestion["title"] ?? "";
    descController.text = widget.suggestion["description"] ?? "";
    locationController.text = widget.suggestion["location"] ?? "";
    existingImage = widget.suggestion["image"];
    selectedCategoryId = widget.suggestion["categoryId"];
    selectedCategoryName = widget.suggestion["categoryName"];
  }

  void pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (kIsWeb) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _image = pickedImage;
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = pickedImage;
        });
      }
    }
  }

  Future<String?> uploadImageToCloudinary(XFile image) async {
    const cloudName = "dhufnlu87";
    const uploadPreset = "MyStore";
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    late http.MultipartFile multipartFile;

    if (kIsWeb) {
      // Web → use bytes
      multipartFile = http.MultipartFile.fromBytes(
        'file',
        _webImage!,
        filename: image.name,
      );
    } else {
      // Mobile → use path
      multipartFile = await http.MultipartFile.fromPath(
        'file',
        image.path,
        filename: image.name,
      );
    }

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(multipartFile);

    final response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonData = json.decode(resStr);
      return jsonData['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> updateSuggestion() async {
    try {
      if (titleController.text.trim().isEmpty ||
          descController.text.trim().isEmpty ||
          locationController.text.trim().isEmpty ||
          selectedCategoryId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
        return;
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

      // Upload new image if selected
      String? finalImageUrl = existingImage;
      if (_image != null) {
        final uploadedUrl = await uploadImageToCloudinary(_image!);
        if (uploadedUrl != null) {
          finalImageUrl = uploadedUrl;
        }
      }

      await FirebaseFirestore.instance
          .collection("eco_travel_suggestions")
          .doc(widget.docId)
          .update({
            "title": titleController.text.trim(),
            "description": descController.text.trim(),
            "location": locationController.text.trim(),
            "image": finalImageUrl,
            "categoryId": selectedCategoryId,
            "categoryName": selectedCategoryName,
            "updatedAt": DateTime.now(),
            "updatedBy": email,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Suggestion updated successfully")),
      );

      Navigator.pop(context); // go back after update
    } catch (e) {
      print("Error updating suggestion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating suggestion")),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Edit Eco Travel Suggestion")),
        ),
        drawer: const Admindrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Title
              TextField(
                controller: titleController,
                decoration: _inputDecoration("Title"),
              ),
              const SizedBox(height: 20),

              /// Description
              TextField(
                controller: descController,
                minLines: 3,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: _inputDecoration("Details"),
              ),
              const SizedBox(height: 20),

              /// Location
              TextField(
                controller: locationController,
                decoration: _inputDecoration("Location"),
              ),
              const SizedBox(height: 20),

              /// Category Dropdown
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("categories")
                    .orderBy("name")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: _inputDecoration("Select Category"),
                    items: categories.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final id = doc.id;
                      final name = data["name"];
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(name),
                        onTap: () {
                          selectedCategoryName = name;
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCategoryId = value);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              /// Image Preview (Web + Mobile + Existing)
              if (_image != null)
                kIsWeb
                    ? Image.memory(_webImage!, height: 150, fit: BoxFit.cover)
                    : Image.file(
                        File(_image!.path),
                        height: 150,
                        fit: BoxFit.cover,
                      )
              else if (existingImage != null)
                Image.network(existingImage!, height: 150, fit: BoxFit.cover)
              else
                const Text("No image selected"),

              const SizedBox(height: 10),
              CustomButton(text: "Pick New Image", onPressed: pickImage),

              const SizedBox(height: 20),
              CustomButton(
                text: "Update Suggestion",
                onPressed: updateSuggestion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
