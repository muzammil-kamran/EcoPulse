import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File; // only for mobile
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EcoTravelSuggestionAddScreen extends StatefulWidget {
  const EcoTravelSuggestionAddScreen({super.key});

  @override
  State<EcoTravelSuggestionAddScreen> createState() =>
      _EcoTravelSuggestionAddScreenState();
}

class _EcoTravelSuggestionAddScreenState
    extends State<EcoTravelSuggestionAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isLoading = false;

  XFile? _image;
  Uint8List? _webImage; // for web image bytes
  final picker = ImagePicker();

  /// Pick image from gallery
  Future<void> pickImage() async {
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

  /// Upload to Cloudinary (works for Web & Mobile)
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
      // Mobile → use file path
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

  /// Save to Firestore
  Future<void> saveSuggestion() async {
    if (!_formKey.currentState!.validate() ||
        _selectedCategoryId == null ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields, select category & upload image",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload Image
      final imageUrl = await uploadImageToCloudinary(_image!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
        setState(() => _isLoading = false);
        return;
      }

      final data = {
        "title": _titleController.text.trim(),
        "description": _descController.text.trim(),
        "location": _locationController.text.trim(),
        "categoryId": _selectedCategoryId,
        "categoryName": _selectedCategoryName,
        "image": imageUrl,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("eco_travel_suggestions")
          .add(data);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving suggestion: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving suggestion")));
    } finally {
      setState(() => _isLoading = false);
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
          title: const Center(child: Text("Add Eco Travel Suggestion")),
        ),
        drawer: const Admindrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Title
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration("Title"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter title" : null,
                ),
                const SizedBox(height: 15),

                /// Description
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: _inputDecoration("Details"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter details" : null,
                ),
                const SizedBox(height: 15),

                /// Location
                TextFormField(
                  controller: _locationController,
                  decoration: _inputDecoration("Location"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter location" : null,
                ),
                const SizedBox(height: 15),

                /// Category Dropdown (ID + Name)
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
                      decoration: _inputDecoration("Select Category"),
                      value: _selectedCategoryId,
                      items: categories.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final id = doc.id;
                        final name = data["name"];
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(name),
                          onTap: () {
                            _selectedCategoryName = name;
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategoryId = value);
                      },
                      validator: (val) =>
                          val == null ? "Please select a category" : null,
                    );
                  },
                ),
                const SizedBox(height: 15),

                /// Image Picker
                _image != null
                    ? kIsWeb
                          ? Image.memory(
                              _webImage!,
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_image!.path),
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                    : const Text("No image selected"),
                const SizedBox(height: 10),
                CustomButton(text: "Pick Image", onPressed: pickImage),

                const SizedBox(height: 25),

                /// Save Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(text: "Save", onPressed: saveSuggestion),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
