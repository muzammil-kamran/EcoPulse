import 'package:ecopulse/Screen/Admin/Categories/Category.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final CategoryNameController = TextEditingController();
  final CategoryDescriptionController = TextEditingController();

  Future<void> createCategory() async {
    try {
      if (CategoryNameController.text.trim().isEmpty ||
          CategoryDescriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
        return;
      }

      // Get user info from SharedPreferences
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

      // Save category to Firestore
      await db.collection("categories").add({
        "name": CategoryNameController.text.trim(),
        "description": CategoryDescriptionController.text.trim(),
        "createdAt": DateTime.now(),
        "createdBy": email,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Category created successfully")));

      // ✅ Navigate to ManageCategoriesScreen after saving
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManageCategoriesScreen()),
      );
    } catch (e) {
      print("Error creating category: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error creating category")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text("Add Category"))),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: CategoryNameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: CategoryDescriptionController,
                minLines: 2,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Category Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(text: "Create Category", onPressed: createCategory),
            ],
          ),
        ),
      ),
    );
  }
}
