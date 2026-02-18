// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'menus/cvs_menu_screen.dart';
import 'menus/resp_menu_screen.dart';
import 'menus/renal_menu_screen.dart';
import 'menus/gi_menu_screen.dart';
import 'menus/endo_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 設定更新日期 (每次更新內容後記得來改這裡)
  final String lastUpdated = "2026/02/16";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICU Pocket Guide'),
        backgroundColor: Colors.grey[850],
        actions: [
          // 右上角資訊按鈕
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Cardiovascular (紅)
          _buildSystemCard(
            context,
            'Cardiovascular\n心血管系統',
            Icons.monitor_heart,
            Colors.redAccent,
            const CvsMenuScreen(),
          ),
          const SizedBox(height: 16),

          // 2. Respiratory (藍)
          _buildSystemCard(
            context,
            'Respiratory\n呼吸系統',
            Icons.air,
            Colors.blueAccent,
            const RespMenuScreen(),
          ),
          const SizedBox(height: 16),

          // 3. Neuro (紫) - Placeholder
          _buildSystemCard(
            context,
            'Neurology\n神經系統',
            Icons.psychology,
            Colors.purpleAccent,
            _buildPlaceholder("Neurology"),
          ),
          const SizedBox(height: 16),

          // 4. GI & Hepatic (橘)
          _buildSystemCard(
            context,
            'GI & Hepatic\n消化與肝膽',
            Icons.medication_liquid,
            Colors.orangeAccent,
            const GiMenuScreen(),
          ),
          const SizedBox(height: 16),

          // 5. Renal & GU (黃)
          _buildSystemCard(
            context,
            'Renal & GU\n腎臟與泌尿',
            Icons.water_drop,
            Colors.yellow[700]!,
            const RenalMenuScreen(),
          ),
          const SizedBox(height: 16),

          // 6. Endo & Meta (綠)
          _buildSystemCard(
            context,
            'Endocrine\n內分泌與代謝',
            Icons.bloodtype,
            Colors.green,
            const EndoMenuScreen(),
          ),
          const SizedBox(height: 16),

          // 7. Infectious (粉) - Placeholder
          _buildSystemCard(
            context,
            'Infectious Dis.\n感染科',
            Icons.bug_report,
            Colors.pinkAccent,
            _buildPlaceholder("Infectious Diseases"),
          ),

          // --- 底部更新日期 ---
          const SizedBox(height: 40),
          Center(
            child: Text(
              "Last Updated: $lastUpdated",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Center(
            child: Text(
              "Designed for Residents",
              style: TextStyle(color: Colors.grey[800], fontSize: 10),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 建構卡片的方法
  Widget _buildSystemCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder 頁面 (給還沒做好的功能用)
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

  // 顯示關於與免責聲明
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "About ICU Pocket Guide",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Version: 1.0.0", style: TextStyle(color: Colors.grey[400])),
            Text(
              "Last Updated: $lastUpdated",
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            const Text(
              "Disclaimer (免責聲明):",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This app is intended for educational purposes only for medical professionals. \n\n"
              "While we strive for accuracy based on standard guidelines (Marino's ICU Book, MICU Guide), medical knowledge changes constantly. \n\n"
              "Always verify drug dosages and protocols with your institution's guidelines and clinical judgment. The developer assumes no liability for errors or outcomes.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
