// lib/screens/menus/cvs_menu_screen.dart
import 'package:flutter/material.dart';
import '../er_meds_screen.dart';
import '../shock_screen.dart'; // <--- 1. 加入這行 import
import '../hf_screen.dart'; // <--- 1. 加入這行 import

class CvsMenuScreen extends StatelessWidget {
  const CvsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cardiovascular System'),
          backgroundColor: Colors.redAccent[700],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "ACLS/Meds"),
              Tab(text: "Shock"),
              Tab(text: "Heart Failure"), // 2. 修改標題
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: TabBarView(
          children: [
            const ErMedsScreen(),
            const ShockScreen(),
            const HfScreen(), // <--- 3. 這裡替換原本的 _buildPlaceholder
          ],
        ),
      ),
    );
  }
}
