import 'package:flutter/material.dart';
import 'package:ecopulse/Screen/User/HomeScreen.dart';
import 'package:ecopulse/Screen/User/Trackers/TrackerMain.dart';
import 'package:ecopulse/Screen/User/Community Forum/ComunityForum.dart';

const Color kGreen = Color(0xFF1E8E3E);
const Color kLightGreen = Color(0xFFE8F6EA);

Widget buildBottomNav({
  required int selectedIndex,
  required Function(int) onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: kLightGreen,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
      ],
    ),
    child: BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: kGreen,
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: (index) => onTap(index),
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.eco_outlined),
          activeIcon: Icon(Icons.eco, color: kGreen),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes_outlined),
          activeIcon: Icon(Icons.track_changes, color: kGreen),
          label: "Trackers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum_outlined),
          activeIcon: Icon(Icons.forum, color: kGreen),
          label: "Forum",
        ),
      ],
    ),
  );
}
