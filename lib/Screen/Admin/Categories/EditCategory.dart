import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Utilities/Contrants.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCategory extends StatefulWidget {
  final String categoryId;

  const EditCategory({super.key, required this.categoryId});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  Future<void> loadCategoryData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        nameController.text = data["name"] ?? "";
        descController.text = data["description"] ?? "";
      }
    } catch (e) {
      print("Error loading category: $e");
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> updateCategory() async {
    try {
      if (nameController.text.trim().isEmpty ||
          descController.text.trim().isEmpty) {
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

      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .update({
            "name": nameController.text.trim(),
            "description": descController.text.trim(),
            "updatedAt": DateTime.now(),
            "updatedBy": email,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category updated successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error updating category: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error updating category")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Edit Category"))),
        drawer: const Admindrawer(),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: descController,
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
                    const SizedBox(height: 20),

                    CustomButton(
                      text: "Update Category",
                      onPressed: updateCategory,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
