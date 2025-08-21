import 'package:ecopulse/Screen/Auth/auth.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/VideoContent/VideoBlogAdd.dart';
import 'package:ecopulse/Widget/AdminDrawer/AdminDrawer.dart';
import 'package:ecopulse/Widget/botton/botton.dart';
import 'package:flutter/material.dart';

class EducationalVideosSreen extends StatelessWidget {
  const EducationalVideosSreen({super.key});

  void GotoAddVideoBlog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVideoBlog()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requiredRole: "Admin",
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text("Add Education Blog"))),
        drawer: Admindrawer(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CustomButton(
                text: "Add Educational Video ",
                onPressed: () => GotoAddVideoBlog(context),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
