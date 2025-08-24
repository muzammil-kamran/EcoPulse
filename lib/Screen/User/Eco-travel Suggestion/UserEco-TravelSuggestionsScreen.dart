import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';

class EcoTravelSuggestionsScreen extends StatefulWidget {
  const EcoTravelSuggestionsScreen({super.key});

  @override
  State<EcoTravelSuggestionsScreen> createState() =>
      _EcoTravelSuggestionsScreenState();
}

class _EcoTravelSuggestionsScreenState
    extends State<EcoTravelSuggestionsScreen> {
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        drawer: const Userdrawer(),
        appBar: AppBar(
          title: const Text("🌱 Eco-Travel Suggestions"),
          centerTitle: true,
          actions: [
            // 🔹 Fetch categories dynamically from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .orderBy("createdAt", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final categories = snapshot.data!.docs;

                return PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_alt),
                  onSelected: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "All",
                      child: Text("All Categories"),
                    ),
                    ...categories.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return PopupMenuItem(
                        value: data["name"],
                        child: Text(data["name"] ?? "Unnamed"),
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("eco_travel_suggestions")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No Eco-Travel Suggestions yet 🌍"),
              );
            }

            final suggestions = snapshot.data!.docs.where((doc) {
              final categoryName = doc["categoryName"] ?? "";
              if (selectedCategory == "All") return true;
              return categoryName == selectedCategory;
            }).toList();

            if (suggestions.isEmpty) {
              return Center(
                child: Text("No suggestions in $selectedCategory category"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion =
                    suggestions[index].data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      suggestion["image"] != null
                          ? Image.network(
                              suggestion["image"],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.green.shade100,
                              child: const Icon(
                                Icons.landscape,
                                size: 80,
                                color: Colors.green,
                              ),
                            ),

                      // Content Section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              suggestion["title"] ?? "No Title",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              suggestion["description"] ?? "No Description",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    suggestion["location"] ??
                                        "Unknown location",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Show category
                            Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 18,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  suggestion["categoryName"] ?? "Uncategorized",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Footer Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: const Border(
                            top: BorderSide(color: Colors.green, width: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "By: ${suggestion["updatedBy"] ?? suggestion["createdBy"] ?? "Admin"}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              suggestion["updatedAt"] != null
                                  ? (suggestion["updatedAt"] as Timestamp)
                                        .toDate()
                                        .toLocal()
                                        .toString()
                                        .split(" ")[0]
                                  : (suggestion["createdAt"] != null
                                        ? (suggestion["createdAt"] as Timestamp)
                                              .toDate()
                                              .toLocal()
                                              .toString()
                                              .split(" ")[0]
                                        : ""),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
