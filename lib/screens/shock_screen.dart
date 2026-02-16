// lib/screens/shock_screen.dart
import 'package:flutter/material.dart';

class ShockScreen extends StatelessWidget {
  const ShockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 核心觀念 (警示卡)
          _buildWarningCard(),
          const SizedBox(height: 16),

          // 2. 血流動力學鑑別 (表格)
          _buildHeader("1. 休克分類與血流動力學 (Hemodynamics)"),
          _buildHemodynamicsTable(),
          const SizedBox(height: 16),

          // 3. 進階監測 (數值意義)
          _buildHeader("2. 進階監測指標 (Advanced Monitoring)"),
          _buildMonitoringSection(),
          const SizedBox(height: 16),

          // 4. 通用處置 (Step-by-Step)
          _buildHeader("3. 通用處置 (General Management)"),
          _buildManagementSteps(),
          const SizedBox(height: 16),

          // 5. 特定治療 (Sepsis, Cardiogenic...)
          _buildHeader("4. 特定休克治療 (Specific Tx)"),
          _buildSpecificTxSection(),
          const SizedBox(height: 16),

          // 6. 復甦目標 (Goals)
          _buildHeader("5. 復甦目標 (Goals of Resuscitation)"),
          _buildGoalCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 核心觀念警示卡 ---
  Widget _buildWarningCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
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
                  "核心觀念 (Core Concepts)",
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
              "• 休克 = 細胞缺氧 (不僅是低血壓)。",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "• 血壓正常也可能休克 (隱形休克)。",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "• 關鍵指標: Lactate > 2 mmol/L, 尿量 < 0.5 mL/kg/hr, 意識改變。",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. 血流動力學表格 ---
  Widget _buildHemodynamicsTable() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 表頭
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Type",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "CVP\n(Preload)",
                      style: TextStyle(color: Colors.tealAccent, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "CO\n(Pump)",
                      style: TextStyle(color: Colors.tealAccent, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "SVR\n(Afterload)",
                      style: TextStyle(color: Colors.tealAccent, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            _buildTableRow(
              "低血容\nHypovolemic",
              "Low ⬇",
              "Low ⬇",
              "High ⬆",
              "出血, 脫水 (冷)",
            ),
            _buildTableRow(
              "心因性\nCardiogenic",
              "High ⬆",
              "Low ⬇",
              "High ⬆",
              "AMI, HF (濕冷)",
            ),
            _buildTableRow(
              "阻塞性\nObstructive",
              "High ⬆",
              "Low ⬇",
              "High ⬆",
              "PE, 氣胸 (頸靜脈怒張)",
            ),
            _buildTableRow(
              "分佈性\nDistributive",
              "Low/Norm",
              "High ⬆",
              "Low ⬇",
              "Sepsis, 過敏 (暖)",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String type,
    String cvp,
    String co,
    String svr,
    String note,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(flex: 2, child: _buildArrowText(cvp)),
              Expanded(flex: 2, child: _buildArrowText(co)),
              Expanded(flex: 2, child: _buildArrowText(svr)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              note,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowText(String text) {
    Color color = Colors.white;
    if (text.contains("High") || text.contains("⬆")) color = Colors.redAccent;
    if (text.contains("Low") || text.contains("⬇")) color = Colors.blueAccent;
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  // --- 3. 進階監測指標 ---
  Widget _buildMonitoringSection() {
    return Column(
      children: [
        _buildMonitorCard(
          "Lactate",
          "> 2 mmol/L",
          "細胞無氧代謝指標 (缺氧)",
          Colors.redAccent,
        ),
        _buildMonitorCard(
          "SVV (Flotrac)",
          "> 10-12%",
          "Hypovolemia (欠水) -> 對輸液有反應",
          Colors.blueAccent,
        ),
        _buildMonitorCard(
          "CI (Cardiac Index)",
          "< 2.5",
          "心臟功能不佳 (Cardiogenic)",
          Colors.orangeAccent,
        ),
        _buildMonitorCard(
          "SVRI",
          "< 1700",
          "血管擴張 (Vasodilation, Sepsis)",
          Colors.purpleAccent,
        ),
        _buildMonitorCard(
          "PCO2 Gap",
          "> 6 mmHg",
          "組織灌流不足 (Low flow state)\n即使 BP 正常，微循環仍差",
          Colors.yellowAccent,
        ),
      ],
    );
  }

  Widget _buildMonitorCard(
    String title,
    String value,
    String desc,
    Color color,
  ) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: ListTile(
        dense: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Text(desc, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }

  // --- 4. 通用處置 ---
  Widget _buildManagementSteps() {
    return Column(
      children: [
        _buildStepTile(
          "Step 1: Fluid (液體復甦)",
          "首選晶體液 (Lactated Ringer's > N/S)",
          [
            "Sepsis: 前 3hr 給予 30 ml/kg",
            "評估: PLR test 或 Fluid challenge (500ml)",
            "目標: 增加 SV 或 BP，避免過負荷",
          ],
          Icons.water_drop,
          Colors.blueAccent,
        ),
        _buildStepTile(
          "Step 2: Vasopressors (升壓)",
          "首選 Norepinephrine (Levophed)",
          [
            "Levophed: Start 2-5 mcg/min (0.05-0.1 mcg/kg/min)",
            "Vasopressin: 第二線。當 Levo > 0.25 mcg/kg/min 時加入。\n   劑量固定 0.03-0.04 U/min。",
            "Phenylephrine: 純 α 作用。僅用於心跳過快時。",
          ],
          Icons.arrow_upward,
          Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildStepTile(
    String title,
    String subtitle,
    List<String> details,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        children: details
            .map(
              (d) => ListTile(
                dense: true,
                leading: const Icon(Icons.circle, size: 6, color: Colors.grey),
                title: Text(d, style: const TextStyle(color: Colors.white70)),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- 5. 特定治療 ---
  Widget _buildSpecificTxSection() {
    return Column(
      children: [
        _buildExpTile("A. 敗血性休克 (Sepsis Bundle)", [
          "1. 測 Lactate, BC x 2, 給廣效抗生素 (1hr內)",
          "2. Fluid 30 ml/kg (若 BP 低或 Lac > 4)",
          "3. 若 MAP < 65: 用 Levophed",
          "4. 若 Refractory: Hydrocortisone 200mg/day",
        ], Colors.orangeAccent),
        _buildExpTile("B. 心因性休克 (Cardiogenic)", [
          "關鍵: 避免過度輸液",
          "Dobutamine: 首選強心 (2-20 mcg/kg/min)。\n   注意: 可能降血壓，需配 Levo",
          "處置: PCI, IABP, ECMO",
        ], Colors.redAccent),
        _buildExpTile("C. 阻塞性休克 (Obstructive)", [
          "氣胸: 針刺減壓 / 胸管",
          "Tamponade: 心包膜穿刺",
          "PE: 溶栓 (Thrombolysis) 或 ECMO",
        ], Colors.purpleAccent),
      ],
    );
  }

  Widget _buildExpTile(String title, List<String> items, Color color) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        children: items
            .map(
              (i) => ListTile(
                dense: true,
                title: Text(i, style: const TextStyle(color: Colors.white70)),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- 6. 復甦目標 ---
  Widget _buildGoalCard() {
    return Card(
      color: Colors.green.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green.withOpacity(0.5)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _GoalRow("MAP", "≥ 65 mmHg"),
            _GoalRow("Urine", "≥ 0.5 mL/kg/hr"),
            _GoalRow("Lactate", "< 2 mmol/L (下降中)"),
            _GoalRow("ScvO2", "> 70%"),
            _GoalRow("PCO2 Gap", "< 6 mmHg"),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final String label;
  final String value;
  const _GoalRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("✅ $label", style: const TextStyle(color: Colors.white)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
