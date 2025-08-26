import 'package:flutter/material.dart';

class WasteCard extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const WasteCard({
    super.key,
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: count > 0 ? onDecrement : null,
                  tooltip: 'Decrease',
                  iconSize: 30,
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text('$count', style: TextStyle(fontSize: 20)),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: onIncrement,
                  tooltip: 'Increase',
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
