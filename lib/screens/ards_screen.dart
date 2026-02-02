// lib/screens/ards_screen.dart
import 'package:flutter/material.dart';
import '../utils/resp_calcs.dart'; // 引入剛剛寫的公式

class ArdsScreen extends StatefulWidget {
  const ArdsScreen({super.key});

  @override
  State<ArdsScreen> createState() => _ArdsScreenState();
}

class _ArdsScreenState extends State<ArdsScreen> {
  // 控制計算機的變數
  final TextEditingController _heightController = TextEditingController();
  bool _isMale = true;
  double? _ibw;
  double? _targetVT;

  void _calculate() {
    if (_heightController.text.isNotEmpty) {
      double height = double.parse(_heightController.text);
      setState(() {
        _ibw = RespCalcs.calculateIBW(height, _isMale);
        _targetVT = RespCalcs.calculateTargetVT(_ibw!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ARDS Protocol")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCalculatorCard(),
          const SizedBox(height: 16),
          _buildSectionTitle("診斷 & 設定"),
          _buildCriteriaCard(),
          _buildVentSettingsCard(),
          const SizedBox(height: 16),
          _buildSectionTitle("藥物治療"),
          _buildDrugCard(),
          const SizedBox(height: 16),
          _buildSectionTitle("救援治療 (Rescue)"),
          _buildRescueCard(),
        ],
      ),
    );
  }

  // 1. IBW 計算機卡片 (這是最常用功能，放最上面)
  Widget _buildCalculatorCard() {
    return Card(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "身高 (cm)",
                      border: OutlineInputBorder(),
                      suffixText: "cm",
                    ),
                    onChanged: (val) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                ToggleButtons(
                  isSelected: [_isMale, !_isMale],
                  onPressed: (index) {
                    setState(() {
                      _isMale = index == 0;
                      _calculate();
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("男"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("女"),
                    ),
                  ],
                ),
              ],
            ),
            if (_ibw != null) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResultItem(
                    "理想體重 (IBW)",
                    "${_ibw!.toStringAsFixed(1)} kg",
                  ),
                  _buildResultItem(
                    "目標 VT (6ml/kg)",
                    "${_targetVT!.toStringAsFixed(0)} ml",
                    isHighlight: true,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 顯示計算結果的小幫手
  Widget _buildResultItem(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.greenAccent : Colors.white,
          ),
        ),
      ],
    );
  }

  // 2. 診斷標準 (折疊選單)
  Widget _buildCriteriaCard() {
    return const ExpansionTile(
      title: Text("1. 診斷標準 (需符合4項)"),
      children: [
        ListTile(
          leading: Icon(Icons.timer, color: Colors.amber),
          title: Text("時效性: 1週內發生"),
        ),
        ListTile(
          leading: Icon(Icons.image, color: Colors.amber),
          title: Text("影像: 雙側肺浸潤 (排除積水/塌陷)"),
        ),
        ListTile(
          leading: Icon(Icons.water_drop, color: Colors.amber),
          title: Text("原因: 非單純心衰竭/水腫"),
        ),
        ListTile(
          leading: Icon(Icons.air, color: Colors.amber),
          title: Text("氧合: PaO2/FiO2 ≤ 300"),
        ),
      ],
    );
  }

  // 3. 呼吸器設定目標
  Widget _buildVentSettingsCard() {
    return ExpansionTile(
      title: const Text("2. Vent 設定目標"),
      initiallyExpanded: true, // 預設展開，因為這是重點
      children: [
        _buildBulletPoint("Mode", "Lung Protective Strategy"),
        _buildBulletPoint("Plateau Pressure", "< 30 cmH2O", isWarning: true),
        _buildBulletPoint("pH 目標", "7.25 - 7.45 (允許高碳酸血症)"),
        _buildBulletPoint("pH < 7.15", "若 RR 達上限 (35)，可給 NaHCO3 (IICP 禁忌)"),
        _buildBulletPoint("氧合目標", "PaO2 55-80 mmHg 或 SpO2 88-95%"),
      ],
    );
  }

  // 4. 藥物治療
  Widget _buildDrugCard() {
    return const ExpansionTile(
      title: Text("3. 鎮靜與肌鬆劑 (Sedation & NMBA)"),
      children: [
        ListTile(
          title: Text(
            "Cisatracurium (Nimbex)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          subtitle: Text(
            "P/F < 150 早期使用 (<48hr)\nLoading: 0.1-0.2 mg/kg\nMaint: 1-3 mcg/kg/min",
          ),
          isThreeLine: true,
        ),
        ListTile(
          title: Text(
            "Fentanyl (止痛)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("泡法: 1000mcg/100ml NS\nInfusion: 5ml/hr (Bolus 5ml)"),
        ),
        ListTile(
          title: Text(
            "Propofol (鎮靜)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "RASS 目標: -3 ~ -4\nDosage: 0.3-3 mg/kg/hr\n注意: Propofol infusion syndrome",
          ),
        ),
      ],
    );
  }

  // 5. 救援治療
  Widget _buildRescueCard() {
    return const ExpansionTile(
      title: Text("4. 救援治療 (Rescue)"),
      children: [
        ListTile(
          leading: Text("P/F < 200", style: TextStyle(color: Colors.orange)),
          title: Text("High PEEP Test (12 cmH2O)"),
          subtitle: Text("注意 Hemodynamics"),
        ),
        ListTile(
          leading: Text("P/F < 150", style: TextStyle(color: Colors.red)),
          title: Text("Prone Position (俯臥)"),
          subtitle: Text("每天至少 16 小時\n禁忌: IICP, 循環不穩"),
        ),
        ListTile(
          leading: Text(
            "P/F < 80",
            style: TextStyle(color: Colors.purpleAccent),
          ),
          title: Text("iNO 或 VV-ECMO"),
          subtitle: Text("需照會 CVS ECMO team"),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBulletPoint(
    String title,
    String content, {
    bool isWarning = false,
  }) {
    return ListTile(
      dense: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        content,
        style: TextStyle(color: isWarning ? Colors.redAccent : Colors.white70),
      ),
    );
  }
}
