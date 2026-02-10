import 'package:flutter/material.dart';

class LungScreen extends StatefulWidget {
  const LungScreen({super.key});

  @override
  State<LungScreen> createState() => _LungScreenState();
}

class _LungScreenState extends State<LungScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isHCAP = false;
  bool _isMRSA = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ★ 修改點：移除 Scaffold/AppBar，使用 Column 包裝內部 TabBar
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          // 內部分頁標籤 (次級導航)
          Container(
            color: Colors.blueGrey[800],
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.tealAccent,
              labelColor: Colors.tealAccent,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Pneumonia"),
                Tab(text: "COPD / Asthma"),
              ],
            ),
          ),
          // 內容區
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPneumoniaTab(), _buildCopdAsthmaTab()],
            ),
          ),
        ],
      ),
    );
  }

  // ... (保留下方 _buildPneumoniaTab, _buildCopdAsthmaTab 等內容，完全不用動) ...
  // (程式碼與之前提供的相同，請貼上即可)
  Widget _buildPneumoniaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. 風險評估 (Risk Assessment)"),
        Card(
          color: Colors.grey[900],
          child: Column(
            children: [
              SwitchListTile(
                title: const Text(
                  "HCAP / HAP 風險?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("護理之家、洗腎、住院>2天"),
                value: _isHCAP,
                activeColor: Colors.orangeAccent,
                onChanged: (v) => setState(() => _isHCAP = v),
              ),
              if (_isHCAP)
                _buildAlertBox(
                  "⚠️ 需覆蓋 Pseudomonas (綠膿桿菌)",
                  Colors.orangeAccent,
                ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text(
                  "MRSA 風險?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("影像有空腔 (Cavitation)、進展快"),
                value: _isMRSA,
                activeColor: Colors.redAccent,
                onChanged: (v) => setState(() => _isMRSA = v),
              ),
              if (_isMRSA) _buildAlertBox("⚠️ 需覆蓋 MRSA", Colors.redAccent),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader("2. 抗生素建議 (2018 Guideline)"),
        _buildAntibioticGroup(
          title: "A. Severe Pneumonia (基本盤)",
          subtitle: "Beta-lactam + (Macrolide 或 Quinolone)",
          color: Colors.blueAccent,
          content: const [
            Text("Beta-lactams: Ceftriaxone, Ertapenem, Unasyn"),
            Text("搭配: Azithromycin 或 Levofloxacin"),
          ],
        ),
        if (_isHCAP)
          _buildAntibioticGroup(
            title: "B. Pseudomonas Coverage",
            subtitle: "需改用以下強效藥物",
            color: Colors.orangeAccent,
            content: const [
              Text("• Tazocin: 4.5g q6h"),
              Text("• Cefepime: 2g q8h"),
              Text("• Meropenem: 1g q8h"),
              Text("Double coverage: + Ciproxin 或 Amikacin"),
            ],
          ),
        if (_isMRSA)
          _buildAntibioticGroup(
            title: "C. MRSA Coverage",
            subtitle: "影像有 Cavitation 時必加",
            color: Colors.redAccent,
            content: const [
              Text("• Vancomycin: 15-20 mg/kg q12h"),
              Text("• Teicoplanin: 6-12 mg/kg q12h"),
              Text("• Linezolid: 600mg q12h"),
            ],
          ),
      ],
    );
  }

  Widget _buildCopdAsthmaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. 支氣管擴張劑"),
        _buildDrugCard("Berodual (SABA+SAMA)", "MDI 4 puff Q6H"),
        _buildDrugCard("ICS + LABA (Foster)", "MDI 2 puff Q12H"),
        _buildDrugCard("Trimbow (LABA+LAMA+ICS)", "MDI 4 puff Q6H"),
        const SizedBox(height: 16),
        _buildSectionHeader("2. 類固醇 (Steroids)"),
        _buildDrugCard("COPD AE", "Prednisolone 40mg PO QD\n療程: 5-14 天"),
        _buildDrugCard("Asthma AE", "Prednisolone 40-60mg PO QD\n療程: 5-7 天"),
      ],
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
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

  Widget _buildAlertBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: color.withOpacity(0.2),
      child: Text(text, style: TextStyle(color: color)),
    );
  }

  Widget _buildAntibioticGroup({
    required String title,
    required String subtitle,
    required Color color,
    required List<Widget> content,
  }) {
    return Card(
      color: Colors.grey[900],
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugCard(String name, String dose) {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(dose, style: const TextStyle(color: Colors.tealAccent)),
      ),
    );
  }
}
