import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'UsersScreen.dart';

class EditUserScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> user;

  const EditUserScreen({super.key, required this.docId, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController roleController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user["Name"]);
    emailController = TextEditingController(text: widget.user["Email"]);
    roleController = TextEditingController(text: widget.user["Role"]);
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(widget.docId)
          .update({
            "Name": nameController.text.trim(),
            "Email": emailController.text.trim(),
            "Role": roleController.text.trim(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User updated successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreen,
      appBar: AppBar(
        title: Text(
          "Edit User",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: kGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter user name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Enter user email" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: roleController,
                decoration: const InputDecoration(labelText: "Role"),
                validator: (value) =>
                    value!.isEmpty ? "Enter role (User/Admin)" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: _updateUser,
                child: Text(
                  "Update User",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
