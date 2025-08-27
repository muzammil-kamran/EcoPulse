import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final double result;

  ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Your Carbon Footprint: ${result.toStringAsFixed(2)} kg CO₂",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
