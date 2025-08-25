import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';

class TrackerMain extends StatefulWidget {
  const TrackerMain({super.key});

  @override
  State<TrackerMain> createState() => _TrackerMainState();
}

class _TrackerMainState extends State<TrackerMain> {
  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text("Trackers"))),
        drawer: Userdrawer(),
      ),
    );
  }
}
