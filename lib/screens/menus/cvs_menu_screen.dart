// lib/screens/menus/cvs_menu_screen.dart
import 'package:flutter/material.dart';
import '../er_meds_screen.dart';
import '../shock_screen.dart';
import '../hf_screen.dart'; // 記得保留這個
import '../arrhythmia_screen.dart'; // <--- 1. 加入這行

class CvsMenuScreen extends StatelessWidget {
  const CvsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // ★ 注意：這裡我們把 Tab 數量改成 4 個，或者把 HF 和 Arrhythmia 放在一起
      // 為了介面整潔，建議改成 4 個 Tabs，或者把 Arrhythmia 獨立
      // 這裡示範改成 4 個 Tab 的版本：
      length: 4, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cardiovascular System'),
          backgroundColor: Colors.redAccent[700],
          // 設定 TabBar 可滑動 (isScrollable: true) 以容納更多 Tab
          bottom: const TabBar(
            isScrollable: true, 
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "ACLS/Meds"),
              Tab(text: "Shock"),
              Tab(text: "Heart Failure"),
              Tab(text: "Arrhythmia"), // <--- 2. 新增這個 Tab
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: TabBarView(
          children: [
            const ErMedsScreen(),
            const ShockScreen(),
            const HfScreen(),
            const ArrhythmiaScreen(), // <--- 3. 對應的頁面
          ],
        ),
      ),
    );
  }
}