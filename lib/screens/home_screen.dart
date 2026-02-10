// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

// 引入各系統的 Menu 頁面
import 'menus/resp_menu_screen.dart';
import 'menus/cvs_menu_screen.dart';
import 'menus/neuro_menu_screen.dart';
// 其他系統暫時用 Placeholder

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String _appVersion = "v2.0.0 (System-Based)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICU Survival Guide'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 2, // 改成兩欄，讓按鈕大一點，方便點擊
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  // 1. Cardiovascular (紅)
                  _buildSystemCard(
                    context,
                    'Cardiovascular\n心血管系統',
                    Icons.monitor_heart,
                    Colors.redAccent,
                    const CvsMenuScreen(),
                  ),
                  // 2. Respiratory (藍)
                  _buildSystemCard(
                    context,
                    'Respiratory\n呼吸系統',
                    Icons.air,
                    Colors.blueAccent,
                    const RespMenuScreen(),
                  ),
                  // 3. Neurological (紫)
                  _buildSystemCard(
                    context,
                    'Neurological\n神經系統',
                    Icons.psychology,
                    Colors.deepPurpleAccent,
                    const NeuroMenuScreen(),
                  ),
                  // 4. GI & Hepatic (橘)
                  _buildSystemCard(
                    context,
                    'GI & Hepatic\n消化與肝膽',
                    Icons.medication_liquid,
                    Colors.orangeAccent,
                    _buildPlaceholder("GI & Hepatic"),
                  ),
                  // 5. Renal & GU (黃)
                  _buildSystemCard(
                    context,
                    'Renal & GU\n腎臟與泌尿',
                    Icons.water_drop,
                    Colors.yellow[700]!,
                    _buildPlaceholder("Renal & GU"),
                  ),
                  // 6. Endo & Meta (綠)
                  _buildSystemCard(
                    context,
                    'Endocrine\n內分泌與代謝',
                    Icons.bloodtype,
                    Colors.green,
                    _buildPlaceholder("Endocrine & Metabolic"),
                  ),
                  // 7. Hematology (深紅)
                  _buildSystemCard(
                    context,
                    'Hematology\n血液系統',
                    Icons.opacity,
                    Colors.red[900]!,
                    _buildPlaceholder("Hematology"),
                  ),
                  // 8. Toxicology (灰)
                  _buildSystemCard(
                    context,
                    'Toxicology\n毒物與環境',
                    Icons.warning_amber,
                    Colors.grey,
                    _buildPlaceholder("Toxicology"),
                  ),
                  // 9. Infectious (青)
                  _buildSystemCard(
                    context,
                    'Infectious ID\n感染科',
                    Icons.bug_report,
                    Colors.teal,
                    _buildPlaceholder("Infectious Disease"),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

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
        side: BorderSide(color: color.withOpacity(0.5), width: 2), // 加個邊框更有質感
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[850],
      child: Column(
        children: [
          const Text(
            "Created by rockynow",
            style: TextStyle(
              color: Colors.white54,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            "Version: $_appVersion",
            style: const TextStyle(color: Colors.white30, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // 暫時用的佔位頁面
  Widget _buildPlaceholder(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "$title\nComing Soon...",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
