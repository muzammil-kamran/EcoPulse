import 'package:ecopulse/Model/WasteReductionTracker/WasteData.dart';
import 'package:ecopulse/Widget/Waste%20Card/WasteCard.dart';
import 'package:flutter/material.dart';

class WasteReductionTracker extends StatefulWidget {
  const WasteReductionTracker({super.key});

  @override
  _WasteReductionTrackerState createState() => _WasteReductionTrackerState();
}

class _WasteReductionTrackerState extends State<WasteReductionTracker> {
  WasteData data = WasteData();

  void _increment(String type) {
    setState(() {
      if (type == 'recycle') data.recycledItems++;
      if (type == 'compost') data.compostedItems++;
      if (type == 'plastic') data.plasticsAvoided++;
    });
  }

  void _decrement(String type) {
    setState(() {
      if (type == 'recycle' && data.recycledItems > 0) data.recycledItems--;
      if (type == 'compost' && data.compostedItems > 0) data.compostedItems--;
      if (type == 'plastic' && data.plasticsAvoided > 0) data.plasticsAvoided--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waste Reduction Tracker")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WasteCard(
              label: "Recycled",
              count: data.recycledItems,
              onIncrement: () => _increment('recycle'),
              onDecrement: () => _decrement('recycle'),
            ),
            WasteCard(
              label: "Composted",
              count: data.compostedItems,
              onIncrement: () => _increment('compost'),
              onDecrement: () => _decrement('compost'),
            ),
            WasteCard(
              label: "Plastic Avoided",
              count: data.plasticsAvoided,
              onIncrement: () => _increment('plastic'),
              onDecrement: () => _decrement('plastic'),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Tip: Reuse containers instead of throwing them away to reduce waste!",
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
