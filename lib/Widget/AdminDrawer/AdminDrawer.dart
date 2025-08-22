import 'package:ecopulse/Screen/Admin/AdminHomeScreen.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/Blogs.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/BlogContent/BlogAdd.dart';
import 'package:ecopulse/Screen/Admin/EducationalContent/VideoContent/VideoBlog.dart';
import 'package:ecopulse/Screen/Auth/LoginScreen.dart';
import 'package:ecopulse/Widget/User%20Draw/UserDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admindrawer extends StatefulWidget {
  const Admindrawer({super.key});

  @override
  State<Admindrawer> createState() => _AdmindrawerState();
}

class _AdmindrawerState extends State<Admindrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text("EcoPulse"),
          ),
          ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHomescreen()),
              );
            },
          ),

          // Educational Content
          ExpansionTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Educational Content"),
            children: [
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text("  Educational Videos"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EducationalVideosSreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text("  Blogs"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BlogsSreen()),
                  );
                },
              ),
            ],
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("LogOut"),

            onTap: () async {
              var pref = await SharedPreferences.getInstance();
              pref.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Loginscreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
