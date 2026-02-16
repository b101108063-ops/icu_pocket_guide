// lib/screens/menus/renal_menu_screen.dart
import 'package:flutter/material.dart';
import '../aki_screen.dart'; // <--- 引入剛剛寫好的 AKI 頁面

class RenalMenuScreen extends StatelessWidget {
  const RenalMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renal & GU System'),
        backgroundColor: Colors.yellow[800],
      ),
      backgroundColor: Colors.grey[900],
      body: const AkiScreen(), // 目前只有 AKI，直接顯示，未來可擴充 Tab
    );
  }
}
