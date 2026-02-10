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
          _buildHeader("1. 休克分類與血流動力學"),
          _buildHemodynamicsTable(),
          const SizedBox(height: 8),
          const Text(
            "註：敗血性休克早期為高 CO、低 SVR；晚期可能轉為低 CO。",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 16),
          _buildHeader("2. 關鍵監測指標 (The 5 Markers)"),
          _buildMonitoringSection(),

          const SizedBox(height: 16),
          _buildHeader("3. 治療策略 (Management)"),
          _buildManagementSteps(),

          const SizedBox(height: 16),
          _buildHeader("4. 復甦目標 (Goals)"),
          _buildGoalCard(),

          const SizedBox(height: 24),
          _buildResidentNote(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 血流動力學表格 ---
  Widget _buildHemodynamicsTable() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTableRow("Type", "CVP", "CO", "SVR", isHeader: true),
            const Divider(color: Colors.white24),
            _buildTableRow("低血容\nHypovolemic", "Low ⬇", "Low ⬇", "High ⬆"),
            _buildTableRow("心因性\nCardiogenic", "High ⬆", "Low ⬇", "High ⬆"),
            _buildTableRow("阻塞性\nObstructive", "High ⬆", "Low ⬇", "High ⬆"),
            _buildTableRow("分佈性\nDistributive", "Low ⬇", "High ⬆", "Low ⬇"),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String type,
    String cvp,
    String co,
    String svr, {
    bool isHeader = false,
  }) {
    TextStyle style = TextStyle(
      color: isHeader ? Colors.tealAccent : Colors.white,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      fontSize: 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              type,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 2, child: _buildArrowText(cvp, isHeader)),
          Expanded(flex: 2, child: _buildArrowText(co, isHeader)),
          Expanded(flex: 2, child: _buildArrowText(svr, isHeader)),
        ],
      ),
    );
  }

  Widget _buildArrowText(String text, bool isHeader) {
    if (isHeader)
      return Text(
        text,
        style: const TextStyle(
          color: Colors.tealAccent,
          fontWeight: FontWeight.bold,
        ),
      );

    Color color = Colors.white;
    if (text.contains("High") || text.contains("⬆")) color = Colors.redAccent;
    if (text.contains("Low") || text.contains("⬇")) color = Colors.blueAccent;

    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  // --- 2. 監測指標 ---
  Widget _buildMonitoringSection() {
    return Column(
      children: [
        _buildMonitorCard(
          "Lactate (乳酸)",
          "> 2 mmol/L",
          "細胞缺氧指標",
          Colors.redAccent,
        ),
        _buildMonitorCard(
          "ScvO2 (靜脈血氧)",
          "< 50%",
          "DO2 (輸送) 不足\n(如：低血容、心因性)",
          Colors.orangeAccent,
        ),
        _buildMonitorCard(
          "ScvO2 (靜脈血氧)",
          "> 80%",
          "VO2 (攝取) 障礙\n(如：敗血性休克分流)",
          Colors.tealAccent,
        ),
        _buildMonitorCard(
          "PCO2 Gap",
          "> 6 mmHg",
          "組織灌流不足 (Low flow)\n微循環障礙指標",
          Colors.purpleAccent,
        ),
        _buildMonitorCard(
          "Urine Output",
          "< 0.5 mL/kg/hr",
          "器官灌流不足早期徵象",
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
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
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
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        subtitle: Text(desc, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }

  // --- 3. 治療策略 ---
  Widget _buildManagementSteps() {
    return Column(
      children: [
        _buildStepTile(
          "Step 1: Fluid (輸液復甦)",
          "首選晶體液 (Crystalloids)",
          [
            "Sepsis: 前 3hr 給予 30 ml/kg",
            "種類: Ringer's Lactate 或 Plasma-Lyte",
            "評估: 看 Fluid Challenge 後的 SV/PPV 變化 (不要只看 CVP)",
          ],
          Icons.water_drop,
          Colors.blueAccent,
        ),
        _buildStepTile(
          "Step 2: Vasopressors (升壓)",
          "首選 Norepinephrine (Levophed)",
          [
            "Levophed: Start 0.05-0.1 mcg/kg/min (5-10 mcg/min)。\n   特點: α1 強力收縮 + 微弱 β1。",
            "Vasopressin: 第二線。當 Levo 高劑量 (>0.25) 時加入。\n   劑量: 固定 0.03-0.04 U/min (不滴定)。",
            "Epinephrine: 過敏性休克首選。敗血症為後線 (易高乳酸)。",
            "Phenylephrine: 純 α 作用。僅用於心跳過快時 (會降 CO)。",
          ],
          Icons.arrow_upward,
          Colors.redAccent,
        ),
        _buildStepTile(
          "Step 3: Inotropes (強心)",
          "CO 低 或 ScvO2 低時使用",
          [
            "Dobutamine: 敗血症合併心肌抑制時使用。",
            "Refractory Shock: 考慮 Hydrocortisone 200mg/day (50mg IV Q6H)。",
          ],
          Icons.monitor_heart,
          Colors.orangeAccent,
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
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60)),
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

  // --- 4. 目標與筆記 ---
  Widget _buildGoalCard() {
    return Card(
      color: Colors.green.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green.withOpacity(0.5)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GoalRow("MAP", "≥ 65 mmHg"),
            _GoalRow("Urine", "> 0.5 mL/kg/hr"),
            _GoalRow("Lactate", "< 2 mmol/L (清除率)"),
            _GoalRow("ScvO2", "> 70%"),
            _GoalRow("PCO2 Gap", "< 6 mmHg"),
          ],
        ),
      ),
    );
  }

  Widget _buildResidentNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "👨‍⚕️ 住院醫師小提醒 (Marino's Note):",
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "1. 低血壓是休克的「結果」而非原因。休克是細胞缺氧。",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "2. 不要只盯著血壓計！誤差很大。請看灌流 (Lactate, Urine, 手腳溫度)。",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "3. 敗血性休克早期識別遵從 qSOFA 或 SOFA。",
            style: TextStyle(color: Colors.white70),
          ),
        ],
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
