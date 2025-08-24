import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Admin/Eco-TravelSuggestion/Eco-TravelSuggestionAdd.dart';
import 'package:ecopulse/Screen/Admin/Eco-TravelSuggestion/Eco-TravelSuggestionEditSceen.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';

class ManageSuggestionsScreen extends StatelessWidget {
  const ManageSuggestionsScreen({super.key});

  void gotoAddSuggestion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EcoTravelSuggestionAddScreen(),
      ),
    );
  }

  void deleteSuggestion(String docId) {
    FirebaseFirestore.instance
        .collection("eco_travel_suggestions")
        .doc(docId)
        .delete();
  }

  void editSuggestion(BuildContext context, DocumentSnapshot suggestionDoc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EcoTravelSuggestionsEditScreen(
          docId: suggestionDoc.id,
          suggestion: suggestionDoc.data() as Map<String, dynamic>,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Manage Suggestions"))),
        drawer: const Admindrawer(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomButton(
                text: "Add New Suggestion",
                onPressed: () => gotoAddSuggestion(context),
              ),
              const SizedBox(height: 20),

              /// Suggestions List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("eco_travel_suggestions")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading suggestions"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final suggestions = snapshot.data!.docs;

                    if (suggestions.isEmpty) {
                      return const Center(child: Text("No suggestions found"));
                    }

                    return ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        final suggestionData =
                            suggestion.data() as Map<String, dynamic>;

                        return Card(
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
                                /// Image (if available)
                                if (suggestionData["image"] != null &&
                                    suggestionData["image"]
                                        .toString()
                                        .isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      suggestionData["image"],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                const SizedBox(height: 10),

                                /// Title
                                Text(
                                  suggestionData["title"] ?? "No Title",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                /// Description
                                Text(
                                  suggestionData["description"] ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 6),

                                /// Location
                                if (suggestionData["location"] != null &&
                                    suggestionData["location"]
                                        .toString()
                                        .isNotEmpty)
                                  Text(
                                    "📍 ${suggestionData["location"]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),

                                const SizedBox(height: 6),

                                /// Category (Name, not ID)
                                if (suggestionData["categoryName"] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      suggestionData["categoryName"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 12),

                                /// Actions
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          editSuggestion(context, suggestion),
                                      icon: const Icon(Icons.edit),
                                      label: const Text("Edit"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          deleteSuggestion(suggestion.id),
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
