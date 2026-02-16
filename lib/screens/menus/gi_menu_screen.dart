// lib/screens/menus/gi_menu_screen.dart
import 'package:flutter/material.dart';
import '../gi_screen.dart';
import '../liver_screen.dart'; // <--- 1. 加入這行

class GiMenuScreen extends StatelessWidget {
  const GiMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GI & Hepatic System'),
        backgroundColor: Colors.orange[800],
      ),
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNavCard(
            context,
            "GI Bleeding",
            "UGIB, EV Bleeding & Massive Transfusion",
            Icons.bloodtype,
            Colors.redAccent,
            const GiScreen(),
          ),
          const SizedBox(height: 16),
          // 2. 更新 Liver Failure 卡片
          _buildNavCard(
            context,
            "Liver Failure",
            "ALF (NAC), ACLF & Complications",
            Icons.science,
            Colors.yellowAccent,
            const LiverScreen(), // <--- 2. 對應頁面
          ),
          const SizedBox(height: 16),
          _buildNavCard(
            context,
            "Pancreatitis & Intra-abd",
            "Severe Pancreatitis & IAI (Coming Soon)",
            Icons.local_hospital,
            Colors.tealAccent,
            _buildPlaceholder("Pancreatitis"),
          ),
        ],
      ),
    );
  }

  // ... (保留 _buildNavCard 和 _buildPlaceholder) ...
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
