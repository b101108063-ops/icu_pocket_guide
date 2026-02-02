// lib/screens/lung_screen.dart
import 'package:flutter/material.dart';

class LungScreen extends StatefulWidget {
  const LungScreen({super.key});

  @override
  State<LungScreen> createState() => _LungScreenState();
}

class _LungScreenState extends State<LungScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 風險評估狀態 (用於動態建議抗生素)
  bool _isHCAP = false; // 是否有綠膿桿菌風險
  bool _isMRSA = false; // 是否有空腔/快速惡化

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
        title: const Text("Lung: Pna / COPD / Asthma"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent,
          labelColor: Colors.tealAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Pneumonia"), // 抗生素
            Tab(text: "COPD/Asthma"), // 噴霧與類固醇
            Tab(text: "Vent/Rescue"), // Auto-PEEP & 波形
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPneumoniaTab(),
          _buildCopdAsthmaTab(),
          _buildVentRescueTab(),
        ],
      ),
    );
  }

  // --- Tab 1: Pneumonia & Antibiotics ---
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
                subtitle: const Text("護理之家、洗腎、住院>2天、近期出院"),
                value: _isHCAP,
                activeColor: Colors.orangeAccent,
                onChanged: (v) => setState(() => _isHCAP = v),
              ),
              if (_isHCAP)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.withOpacity(0.2),
                  width: double.infinity,
                  child: const Text(
                    "⚠️ 需覆蓋 Pseudomonas (綠膿桿菌)",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text(
                  "MRSA 風險?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("影像有空腔 (Cavitation)、進展快速"),
                value: _isMRSA,
                activeColor: Colors.redAccent,
                onChanged: (v) => setState(() => _isMRSA = v),
              ),
              if (_isMRSA)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.withOpacity(0.2),
                  width: double.infinity,
                  child: const Text(
                    "⚠️ 需覆蓋 MRSA",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader("2. 抗生素建議 (2018 Guideline)"),

        // A. 社區/嚴重肺炎 (基本盤)
        _buildAntibioticGroup(
          title: "A. Severe Pneumonia (基本盤)",
          subtitle: "Beta-lactam + (Macrolide 或 Quinolone)",
          color: Colors.blueAccent,
          content: const [
            Text(
              "Beta-lactams (擇一):",
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
            Text("• Ceftriaxone: 2g QD"),
            Text("• Cefotaxime: 1-2g q8h"),
            Text("• Ertapenem: 1g QD"),
            Text("• Unasyn: 1.5-3g q6h"),
            SizedBox(height: 8),
            Text("搭配 (擇一):", style: TextStyle(color: Colors.lightBlueAccent)),
            Text("• Azithromycin: 500mg PO QD"),
            Text("• Levofloxacin: 500-750mg QD (需驗3套TB)"),
          ],
        ),

        // B. 綠膿桿菌 (動態顯示)
        if (_isHCAP)
          _buildAntibioticGroup(
            title: "B. Pseudomonas Coverage (綠膿)",
            subtitle: "需改用以下強效藥物",
            color: Colors.orangeAccent,
            content: const [
              Text("主要藥物 (擇一):", style: TextStyle(color: Colors.orangeAccent)),
              Text("• Tazocin: 4.5g q6h-q8h"),
              Text("• Cefepime: 2g q8h"),
              Text("• Meropenem: 1g q8h (或 Imipenem)"),
              Text("• Bonsulpra: 4g q12h"),
              SizedBox(height: 8),
              Text(
                "可考慮合併 (Double coverage):",
                style: TextStyle(color: Colors.orangeAccent),
              ),
              Text("• Ciproxin 400mg q8-12h"),
              Text("• Amikacin 15-20mg/kg QD"),
            ],
          ),

        // C. MRSA (動態顯示)
        if (_isMRSA)
          _buildAntibioticGroup(
            title: "C. MRSA Coverage",
            subtitle: "影像有 Cavitation 時必加",
            color: Colors.redAccent,
            content: const [
              Text("藥物選擇:", style: TextStyle(color: Colors.redAccent)),
              Text("• Vancomycin: 15-20 mg/kg q12h"),
              Text("• Teicoplanin: 6-12 mg/kg q12h (前3-5劑需 Loading)"),
              Text("• Linezolid: 600mg q12h"),
            ],
          ),
      ],
    );
  }

  // --- Tab 2: COPD / Asthma ---
  Widget _buildCopdAsthmaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. 支氣管擴張劑 (Bronchodilators)"),
        const Card(
          color: Colors.black45,
          child: ListTile(
            leading: Icon(Icons.info_outline, color: Colors.yellow),
            title: Text("優先使用 MDI (定量噴霧)"),
            subtitle: Text("取代 Nebulizer 以減少氣溶膠傳播。\n呼吸器病人劑量需較高。"),
          ),
        ),
        _buildDrugCard("Berodual (SABA+SAMA)", "MDI 4 puff Q6H"),
        _buildDrugCard("ICS + LABA (Foster/Symbicort)", "MDI 2 puff Q12H"),
        _buildDrugCard("Trimbow (LABA+LAMA+ICS)", "MDI 4 puff Q6H"),

        const SizedBox(height: 16),
        _buildSectionHeader("2. 類固醇 (Steroids)"),
        _buildDrugCard("COPD AE", "Prednisolone 40mg PO QD\n療程: 5-14 天"),
        _buildDrugCard("Asthma AE", "Prednisolone 40-60mg PO QD\n療程: 5-7 天"),
      ],
    );
  }

  // --- Tab 3: Vent & Rescue ---
  Widget _buildVentRescueTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("緊急狀況: Auto-PEEP (Air Trapping)"),
        Card(
          color: Colors.red[900]!.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      "危急處置 (Hypotension/Desat)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.redAccent),
                const Text(
                  "1. Disconnect Ventilator (拔管路)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text("   讓氣體排出 (Air release)，用 Ambu 壓並抽痰。"),
                const SizedBox(height: 8),
                const Text(
                  "2. 接回後調整設定:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text("   • 降低 Ti (吸氣時間) 至 0.9-1.5s"),
                const Text("   • 給予支氣管擴張劑"),
                const Text("   • 允許 Permissive Hypercapnia"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader("波形判讀 (Waveforms)"),
        const ListTile(
          leading: Icon(Icons.waves, color: Colors.tealAccent),
          title: Text("Scooping Sign (凹陷)"),
          subtitle: Text(
            "Flow-Volume curve 吐氣端出現凹陷。\n代表：呼吸道阻力增加 (Asthma/COPD)。",
          ),
        ),
        const ListTile(
          leading: Icon(Icons.loop, color: Colors.tealAccent),
          title: Text("Auto-PEEP 圖形"),
          subtitle: Text(
            "Flow-Volume loop 吐氣端「回不了原點」。\n處置：請 RT 測量 Intrinsic PEEP。",
          ),
        ),
      ],
    );
  }

  // --- Helpers ---

  Widget _buildSectionHeader(String title) {
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

  Widget _buildAntibioticGroup({
    required String title,
    required String subtitle,
    required Color color,
    required List<Widget> content,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
        subtitle: Text(
          dose,
          style: const TextStyle(color: Colors.tealAccent, fontSize: 15),
        ),
      ),
    );
  }
}
