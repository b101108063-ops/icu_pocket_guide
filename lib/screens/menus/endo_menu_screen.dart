// lib/screens/menus/endo_menu_screen.dart
import 'package:flutter/material.dart';
import '../endo_screen.dart';
import '../thyroid_screen.dart';
import '../adrenal_screen.dart'; // <--- 1. 加入這行

class EndoMenuScreen extends StatelessWidget {
  const EndoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endocrine & Metabolic'),
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNavCard(
            context,
            "Glycemic Emergencies",
            "DKA, HHS, AKA & Calculators",
            Icons.water_drop,
            Colors.greenAccent,
            const EndoScreen(),
          ),
          const SizedBox(height: 16),
          _buildNavCard(
            context,
            "Thyroid Emergencies",
            "Thyroid Storm & Myxedema Coma",
            Icons.ac_unit,
            Colors.orangeAccent,
            const ThyroidScreen(),
          ),
          const SizedBox(height: 16),
          // 2. 新增 Adrenal 卡片
          _buildNavCard(
            context,
            "Adrenal Insufficiency",
            "CIRCI, Septic Shock & Crisis",
            Icons.flash_on, // 使用閃電代表 Crisis/Shock
            Colors.redAccent,
            const AdrenalScreen(),
          ),
          const SizedBox(height: 16),
          _buildNavCard(
            context,
            "Electrolytes",
            "Na, K, Ca, P, Mg Correction (Coming Soon)",
            Icons.science,
            Colors.tealAccent,
            _buildPlaceholder("Electrolytes"),
          ),
        ],
      ),
    );
  }

  // ... (保留 _buildNavCard 和 _buildPlaceholder, 不用動)
  Widget _buildNavCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Card(
      color: Colors.grey[850],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: color, size: 40),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.grey[850]),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Text(
          "$title\nComing Soon...",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
    );
  }
}
