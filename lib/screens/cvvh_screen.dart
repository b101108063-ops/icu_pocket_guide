// lib/screens/cvvh_screen.dart
import 'package:flutter/material.dart';

class CvvhScreen extends StatefulWidget {
  const CvvhScreen({super.key});

  @override
  State<CvvhScreen> createState() => _CvvhScreenState();
}

class _CvvhScreenState extends State<CvvhScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _weightController = TextEditingController();

  // 狀態變數
  double _weight = 60.0;
  bool _isShock = false; // 用於判斷 Fluid removal
  bool _isBleeding = false; // 用於判斷 Heparin

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _weightController.text = "60";
    _weightController.addListener(() {
      setState(() {
        _weight = double.tryParse(_weightController.text) ?? 60.0;
      });
    });
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
        title: const Text("CRRT: CVVH / CVVHDF"),
        backgroundColor: Colors.cyan[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "CVVH (oXiris)"),
            Tab(text: "CVVHDF"),
            Tab(text: "Heparin & K"),
          ],
        ),
      ),
      body: Column(
        children: [
          // 全域設定區：體重與狀態
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                    decoration: const InputDecoration(
                      labelText: "病人體重 (kg)",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    _buildToggle(
                      "Shock (No Dehy)",
                      _isShock,
                      (v) => setState(() => _isShock = v),
                    ),
                    _buildToggle(
                      "Bleeding Risk",
                      _isBleeding,
                      (v) => setState(() => _isBleeding = v),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 分頁內容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCvvhTab(),
                _buildCvvhdfTab(),
                _buildHeparinTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 1: CVVH (Convection) ---
  Widget _buildCvvhTab() {
    // 計算邏輯
    double replacementRate = _weight * 35; // 35 ml/kg/hr
    double totalVol24h = replacementRate * 24;
    int bags = (totalVol24h / 5000).ceil(); // 無條件進位

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. 適應症 & 設定 (Convection)"),
        const Card(
          color: Colors.black45,
          child: ListTile(
            title: Text("Indications"),
            subtitle: Text(
              "• 難治型高血鉀/酸中毒/水腫\n• oXiris: 懷疑 Cytokine Storm / GNB Sepsis",
            ),
          ),
        ),

        const SizedBox(height: 10),
        _buildSectionHeader("2. Order Calculator (醫令計算)"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResultRow(
                  "Replacement Rate",
                  "${replacementRate.toStringAsFixed(0)} ml/hr",
                  "(35 ml/kg/hr)",
                ),
                const Divider(),
                _buildResultRow("Prismasol Bags", "$bags 包 / QD", "(總量/5000)"),
                const SizedBox(height: 8),
                const Text(
                  "PBP (Flush): 固定 6000 ml QD",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        _buildSectionHeader("3. Basic Settings"),
        _buildSettingCard([
          "Blood Flow: 200 ml/hr",
          "Fluid Removal (脫水): ${_isShock ? '0 (Shock 勿脫水)' : '50-200'} ml/hr",
          "oXiris 特別醫令: 加驗 Q8H CRP, PCT, Lactate",
        ]),
      ],
    );
  }

  // --- Tab 2: CVVHDF (Diffusion + Convection) ---
  Widget _buildCvvhdfTab() {
    // 計算邏輯
    double dialysisRate = _weight * 25; // 25 ml/kg/hr

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. 設定目標 (Diffusion 為主)"),
        const Card(
          color: Colors.black45,
          child: ListTile(
            title: Text("CRRT II 組套"),
            subtitle: Text("適用：需清除小分子毒素 / 嚴重酸中毒"),
          ),
        ),

        const SizedBox(height: 10),
        _buildSectionHeader("2. Dialysis Fluid Calculator"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResultRow(
                  "Dialysis Fluid",
                  "${dialysisRate.toStringAsFixed(0)} ml/hr",
                  "(25 ml/kg/hr)",
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.withOpacity(0.2),
                  child: const Text(
                    "調整: 若嚴重酸中毒/高血鉀，可 +500~1000 ml",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        _buildSectionHeader("3. Basic Settings"),
        _buildSettingCard([
          "Blood Flow: 150 - 200 ml/hr",
          "Effluent Flow Target: 35 ml/kg/hr",
          "PBP / Replacement: 250 - 1000 ml/hr (Titratable)",
          "Fluid Removal: ${_isShock ? '0' : '0 - 200'} ml/hr",
        ]),
      ],
    );
  }

  // --- Tab 3: Heparin & Electrolytes ---
  Widget _buildHeparinTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Heparin Protocol
        _buildSectionHeader("1. Anticoagulant (Heparin)"),
        if (_isBleeding)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.red[900],
            child: const Row(
              children: [
                Icon(Icons.block, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Bleeding Risk: DO NOT use Heparin!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        else
          Card(
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                _buildOrderTile(
                  "Priming (預沖)",
                  "Heparin 2000u ST (入 1000ml NS)",
                ),
                const Divider(height: 1),
                _buildOrderTile(
                  "Maintenance",
                  "Heparin 1000u Q4H (入 20ml NS)\nRate: 5 ml/hr",
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "註: 約 5-20 u/kg/hr，可依 Order titrate",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // Electrolytes
        _buildSectionHeader("2. Electrolyte Protocol (K < 3.5)"),
        Card(
          color: Colors.grey[850],
          child: Column(
            children: [
              _buildOrderTile("補充時機", "K < 3.5 mEq/L"),
              _buildOrderTile(
                "處方 (KCl)",
                "每包 Prismasol 加 0.5 - 1.5 amp\n(10 - 30 mEq)",
              ),
              _buildOrderTile(
                "加入位置",
                "CVVH: 加在 Replacement\nCVVHDF: 加在 Dialysate",
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.yellow[900]!.withOpacity(0.5),
                child: const Text(
                  "上限: 每包最多加 1.5 支 KCl",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.yellowAccent),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("3. Routine Labs"),
        _buildSettingCard([
          "Q6H: Na, K, Ca, ABG",
          "QD: Mg, P",
          "oXiris: 加驗 Q8H PCT, CRP",
        ]),
      ],
    );
  }

  // --- UI Helpers ---

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: value ? Colors.redAccent : Colors.grey,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: value ? Colors.redAccent : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

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

  Widget _buildResultRow(String label, String value, String sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(List<String> items) {
    return Card(
      color: Colors.grey[900],
      child: Column(
        children: items
            .map(
              (item) => ListTile(
                dense: true,
                leading: const Icon(
                  Icons.settings,
                  color: Colors.cyan,
                  size: 16,
                ),
                title: Text(item),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildOrderTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.cyanAccent),
      ),
    );
  }
}
