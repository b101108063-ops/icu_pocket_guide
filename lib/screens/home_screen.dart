// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

// 引入所有我們做好的模組
import 'ards_screen.dart';
import 'sedation_screen.dart';
import 'sepsis_screen.dart';
import 'lung_screen.dart';
import 'rosc_screen.dart';
import 'gib_screen.dart';
import 'cvs_screen.dart';
import 'neuro_screen.dart';
import 'seizure_screen.dart';
import 'meningitis_screen.dart';
import 'resp_procedure_screen.dart';
import 'aline_screen.dart';
import 'cvvh_screen.dart';
import 'icu_meds_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 目前顯示在首頁的版本號
  final String _currentVersion = "v1.3.0";

  // 詳細的更新日誌 (最新的放最上面)
  final List<Map<String, String>> _versionHistory = const [
    {
      "version": "v1.3.0 (2026.02.04)",
      "content":
          "• 新增 A-line 操作與波形判讀\n• 新增 Flotrac 休克鑑別矩陣\n• 新增 CVVH 洗腎劑量計算機\n• 升級 CVS 模組 (IABP, ECMO 詳細圖解)",
    },
    {
      "version": "v1.2.0 (2026.02.01)",
      "content":
          "• 新增 Neuro 模組 (Stroke, Seizure, Meningitis)\n• 新增 呼吸器脫離指標 (RSBI) 計算機\n• 新增 拔管前測試 (Cuff Leak) 計算機",
    },
    {
      "version": "v1.1.0 (2026.01.28)",
      "content": "• 新增 Sepsis 敗血症指引\n• 新增 GI Bleeding 處置流程\n• 介面優化：首頁改為九宮格佈局",
    },
    {
      "version": "v1.0.0 (2026.01.20)",
      "content": "• App 初始發布\n• 包含基礎 ARDS, CVS, ACLS 功能",
    },
  ];

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
          // 上半部：功能九宮格
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  // --- Respiratory System ---
                  _buildMiniCard(
                    context,
                    'ARDS / Vent',
                    Icons.air,
                    Colors.blueAccent,
                    const ArdsScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'Pna / COPD',
                    Icons.masks,
                    Colors.blueAccent,
                    const LungScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'Vent / Lines',
                    Icons.settings_input_composite,
                    Colors.teal,
                    const RespProcedureScreen(),
                  ),

                  // --- Cardiovascular System ---
                  _buildMiniCard(
                    context,
                    'CVS / Shock',
                    Icons.monitor_heart,
                    Colors.cyanAccent,
                    const CvsScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'Sepsis / Fluids',
                    Icons.water_drop,
                    Colors.cyan,
                    const SepsisScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'A-line / Flotrac',
                    Icons.show_chart,
                    Colors.deepOrangeAccent,
                    const AlineScreen(),
                  ),

                  _buildMiniCard(
                    context,
                    'ER/ICU Meds',
                    Icons.medication_liquid, // 推薦使用點滴或藥物圖示
                    Colors.redAccent, // 使用紅色突顯急救性質
                    const ErMedsScreen(),
                  ),

                  // --- Renal / GI ---
                  _buildMiniCard(
                    context,
                    'CRRT / oXiris',
                    Icons.cleaning_services,
                    Colors.blueGrey,
                    const CvvhScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'GI Bleeding',
                    Icons.bloodtype,
                    Colors.red[700]!,
                    const GibScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'ROSC / TTM',
                    Icons.ac_unit,
                    Colors.lightBlue,
                    const RoscScreen(),
                  ),

                  // --- Neuro System ---
                  _buildMiniCard(
                    context,
                    'Stroke / ICH',
                    Icons.flash_on,
                    Colors.indigoAccent,
                    const NeuroScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'Seizure',
                    Icons.electric_bolt,
                    Colors.purpleAccent,
                    const SeizureScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'Meningitis',
                    Icons.psychology_alt,
                    Colors.deepPurple,
                    const MeningitisScreen(),
                  ),
                  _buildMiniCard(
                    context,
                    'Sedation / PAD', // 標題
                    Icons.nights_stay, // 使用月亮圖示代表鎮靜/睡眠
                    Colors.deepPurpleAccent, // 紫色系
                    const SedationScreen(),
                  ),
                ],
              ),
            ),
          ),

          // 下半部：Footer (可點擊查看更新日誌)
          GestureDetector(
            onTap: () => _showChangelog(context), // 點擊觸發彈窗
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.grey[850], // 稍微亮一點的灰色，暗示可點擊
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Created by rockynow",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Version: $_currentVersion",
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white30,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 顯示更新日誌的彈出視窗
  void _showChangelog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Version History",
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _versionHistory.length,
              itemBuilder: (context, index) {
                final item = _versionHistory[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["version"]!,
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["content"]!,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const Divider(color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.cyanAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // 小卡片元件
  Widget _buildMiniCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Card(
      color: Colors.grey[900],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
