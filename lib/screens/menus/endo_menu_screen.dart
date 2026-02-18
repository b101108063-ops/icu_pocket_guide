// lib/screens/menus/endo_menu_screen.dart
import 'package:flutter/material.dart';
import '../endo_screen.dart';
import '../thyroid_screen.dart';
import '../adrenal_screen.dart';

class EndoMenuScreen extends StatelessWidget {
  const EndoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 4個分頁
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Endocrine & Metabolic'),
          backgroundColor: Colors.green[800],
          bottom: const TabBar(
            isScrollable: true, // 允許滑動以容納更多標籤
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "Glycemic (DKA)"), // 對應 EndoScreen
              Tab(text: "Thyroid"), // 對應 ThyroidScreen
              Tab(text: "Adrenal"), // 對應 AdrenalScreen
              Tab(text: "Electrolytes"), // Placeholder
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: TabBarView(
          children: [
            const EndoScreen(), // 裡面還有自己的小 Tab (DKA/Calc)，這是允許的 (巢狀 Tab)
            const ThyroidScreen(), // 裡面也有自己的小 Tab (Storm/Coma)
            const AdrenalScreen(), // 我們等下把它的 Scaffold 拿掉
            _buildPlaceholder("Electrolytes Correction"),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        "$title\nComing Soon...",
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }
}
