// lib/screens/menus/cvs_menu_screen.dart
import 'package:flutter/material.dart';
import '../er_meds_screen.dart';
import '../shock_screen.dart';
import '../hf_screen.dart';
import '../arrhythmia_screen.dart';
import '../arrest_screen.dart';
import '../acs_screen.dart'; // <--- 1. 加入這行

class CvsMenuScreen extends StatelessWidget {
  const CvsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // <--- 2. 改成 6 個 Tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cardiovascular System'),
          backgroundColor: Colors.redAccent[700],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "Cardiac Arrest"),
              Tab(text: "ACS / MI"), // <--- 3. 新增這個 Tab (建議放第二個)
              Tab(text: "ACLS/Meds"),
              Tab(text: "Shock"),
              Tab(text: "Heart Failure"),
              Tab(text: "Arrhythmia"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: TabBarView(
          children: [
            const ArrestScreen(),
            const AcsScreen(), // <--- 4. 對應的頁面
            const ErMedsScreen(),
            const ShockScreen(),
            const HfScreen(),
            const ArrhythmiaScreen(),
          ],
        ),
      ),
    );
  }
}
