// lib/screens/flotrac_screen.dart
import 'package:flutter/material.dart';

class FlotracScreen extends StatefulWidget {
  const FlotracScreen({super.key});

  @override
  State<FlotracScreen> createState() => _FlotracScreenState();
}

class _FlotracScreenState extends State<FlotracScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flotrac: Shock Guide"),
        backgroundColor: Colors.cyan[800], // 科技感藍綠色
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          tabs: const [
            Tab(text: "Interpretation"), // 判讀與鑑別
            Tab(text: "Management"), // 治療策略
            Tab(text: "Note & Tips"), // 紀錄與排除
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInterpretationTab(),
          _buildManagementTab(),
          _buildNoteTab(),
        ],
      ),
    );
  }

  // --- Tab 1: Interpretation (核心判讀) ---
  Widget _buildInterpretationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. 使用前提 (Prerequisites)
        Card(
          color: Colors.red[900]!.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent),
          ),
          child: const ListTile(
            leading: Icon(Icons.gavel, color: Colors.redAccent),
            title: Text(
              "使用前提 (Prerequisites)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text("1. 無自發性呼吸 (No Spont)\n2. 規律心跳 (No Arrhythmia)"),
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("1. Key Parameters (關鍵參數)"),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 8,
          children: [
            _buildParamBox("SVV", "> 10-12%", "Preload", Colors.blueAccent),
            _buildParamBox("CI", "3.0 - 5.0", "Pump", Colors.greenAccent),
            _buildParamBox(
              "SVRI",
              "1700-2400",
              "Afterload",
              Colors.purpleAccent,
            ),
          ],
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. Shock Differential Matrix (鑑別診斷)"),
        Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2), // Type
                1: FlexColumnWidth(1.2), // SVV
                2: FlexColumnWidth(1.2), // CI
                3: FlexColumnWidth(1.2), // SVRI
              },
              children: [
                _buildTableRow("Type", "SVV", "CI", "SVRI", isHeader: true),
                _buildTableRow(
                  "Hypovolemic\n(低血容)",
                  "High\n(欠水)",
                  "Low",
                  "High",
                  highlightColor: Colors.blue[900],
                ),
                _buildTableRow(
                  "Cardiogenic\n(心因性)",
                  "Low",
                  "Low\n(沒力)",
                  "High",
                  highlightColor: Colors.red[900],
                ),
                _buildTableRow(
                  "Septic\n(敗血性)",
                  "Var",
                  "High",
                  "Low\n(太鬆)",
                  highlightColor: Colors.purple[900],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Tab 2: Management (GDT) ---
  Widget _buildManagementTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("Goal-Directed Therapy (GDT)"),

        // Strategy 1: SVV High -> Fluid
        _buildActionCard(
          condition: "SVV > 10 - 12%",
          action: "Fluid Challenge (輸液復甦)",
          drug: "Balanced Crystalloids",
          icon: Icons.water_drop,
          color: Colors.blueAccent,
        ),

        // Strategy 2: SVRI Low -> Vasopressor
        _buildActionCard(
          condition: "SVRI Low (< 1700)",
          action: "Vasopressors (升壓劑)",
          drug: "1. Levophed (Target MAP ≥ 65)\n2. Vasopressin (Pitressin)",
          icon: Icons.compress,
          color: Colors.purpleAccent,
        ),

        // Strategy 3: CI Low -> Inotrope
        _buildActionCard(
          condition: "CI Low (< 3.0)",
          action: "Inotropes (強心劑)",
          drug: "Dobutamine / Epinephrine",
          icon: Icons.monitor_heart,
          color: Colors.redAccent,
        ),

        const Divider(height: 30),
        _buildSectionHeader("藥物紀錄重點"),
        const Card(
          color: Colors.black45,
          child: ListTile(
            title: Text("Procedure Note 必填"),
            subtitle: Text("記錄當下 TPR 以及正在使用的 Inotropic agent 劑量"),
          ),
        ),
      ],
    );
  }

  // --- Tab 3: Note & Troubleshooting ---
  Widget _buildNoteTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. Procedure Note Template"),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            border: Border.all(color: Colors.cyanAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const SelectableText(
            // 讓醫師可以長按複製
            """
Procedure: Flotrac Hemodynamic Monitoring
---
Measurements:
- C.O / C.I:  [   ] / [   ]
- SVV:        [   ] %
- SVRI:       [   ]

Vital Signs:
- T/P/R:      [   ] / [   ] / [   ]
- BP (MAP):   [   ]
- CVP:        [   ]

Current Meds:
- Levophed:   [   ] mcg/min
- Dopamine:   [   ] mcg/kg/min
- Dobutamine: [   ] mcg/kg/min

Impression:
(e.g., Mixed Shock: Septic + Cardiogenic)

Plan:
(e.g., Fluid challenge, Titrate Levophed)
            """,
            style: TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text("(長按可選取文字)", style: TextStyle(color: Colors.grey)),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. Troubleshooting (異常排除)"),
        _buildTroubleTile("Over-damping (波形鈍)", "氣泡/折管 -> SBP 低估"),
        _buildTroubleTile("Under-damping (震盪大)", "心跳快/管路長 -> SBP 高估"),
      ],
    );
  }

  // --- UI Helpers ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParamBox(String title, String value, String desc, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    String c1,
    String c2,
    String c3,
    String c4, {
    bool isHeader = false,
    Color? highlightColor,
  }) {
    final style = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? Colors.cyanAccent : Colors.white,
      fontSize: 13,
    );

    return TableRow(
      decoration: BoxDecoration(color: highlightColor?.withOpacity(0.3)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(c1, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(c2, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(c3, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(c4, style: style),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String condition,
    required String action,
    required String drug,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          condition,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "→ $action",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(drug, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleTile(String title, String subtitle) {
    return Card(
      color: Colors.black45,
      child: ListTile(
        leading: const Icon(Icons.build, color: Colors.grey),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.orangeAccent),
        ),
      ),
    );
  }
}
