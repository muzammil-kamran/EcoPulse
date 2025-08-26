import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/CarbonTracker/calculator .dart';
import 'package:ecopulse/Widget/CarbonTracker/result.card.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';

class TrackerScreen extends StatefulWidget {
  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final transportController = TextEditingController();
  final electricityController = TextEditingController();
  final foodController = TextEditingController();

  double result = 0;

  void calculate() {
    double transport = double.tryParse(transportController.text) ?? 0;
    double electricity = double.tryParse(electricityController.text) ?? 0;
    double food = double.tryParse(foodController.text) ?? 0;

    setState(() {
      result = Calculator.calculateFootprint(
        transport: transport,
        electricity: electricity,
        food: food,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "User",
      child: Scaffold(
        appBar: AppBar(title: Text("Carbon Footprint Tracker")),
        // drawer: Userdrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: transportController,
                decoration: InputDecoration(
                  labelText: "Transport (liters of fuel)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: electricityController,
                decoration: InputDecoration(labelText: "Electricity (kWh)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: foodController,
                decoration: InputDecoration(
                  labelText: "Meals with meat (per month)",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              CustomButton(text: ("Calculate"), onPressed: calculate),

              SizedBox(height: 20),
              ResultCard(result: result),
            ],
          ),
        ),
      ),
    );
  }
}
