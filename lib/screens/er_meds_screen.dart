import 'package:flutter/material.dart';

class ErMedsScreen extends StatelessWidget {
  const ErMedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ★ 修改點：移除 Scaffold/AppBar，回傳 Container
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. 最上方的警示卡
          _buildWarningCard(),
          const SizedBox(height: 16),
          // ... 其餘內容
          _buildSectionHeader("A. 抗心律不整 (Antiarrhythmic)"),
          _buildDrugCard("Adenosine", "6mg/2ml", [
            "用法: IV rapid push (1-3s) + N/S 20ml flush",
            "劑量: 6mg ⮕ 12mg ⮕ 12mg",
          ], Colors.redAccent),
          _buildDrugCard("Amiodarone", "150mg/3ml", [
            "⚠️ 泡製: 限用 D5W",
            "Loading: 150mg/100ml D5W run 10min",
          ], Colors.redAccent),

          // (為了節省篇幅，這裡省略中間重複的藥物列表，請保留原檔案內容)
          const SizedBox(height: 16),
          _buildSectionHeader("B. 升壓與強心"),
          _buildDrugCard("Norepinephrine", "4mg/4ml", [
            "泡製: 2amp+D5W 92ml",
            "Start 0.1-0.2 mcg/kg/min",
          ], Colors.tealAccent),
          // ...
        ],
      ),
    );
  }

  // ... (保留下方的 Helper Widgets: _buildWarningCard, _buildDrugCard 等，不用動) ...
  Widget _buildWarningCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orangeAccent),
                SizedBox(width: 8),
                Text(
                  "重要使用須知",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "1. 泡製濃度: 各醫院 Pump 泡法可能不同，請務必核對單位。",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "2. Amiodarone: 僅可用 D5W 稀釋。",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey[400]!, width: 4)),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDrugCard(
    String drugName,
    String spec,
    List<String> details,
    Color accentColor,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    drugName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    spec,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            ...details
                .map(
                  (detail) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "• $detail",
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
