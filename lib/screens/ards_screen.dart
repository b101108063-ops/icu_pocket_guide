// lib/screens/ards_screen.dart
import 'package:flutter/material.dart';
import '../utils/resp_calcs.dart';

class ArdsScreen extends StatefulWidget {
  const ArdsScreen({super.key});

  @override
  State<ArdsScreen> createState() => _ArdsScreenState();
}

class _ArdsScreenState extends State<ArdsScreen> {
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
      appBar: AppBar(
        title: const Text("ARDS Protocol"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCalculatorCard(),
          const SizedBox(height: 16),
          _buildSectionTitle("1. 診斷 & 設定"),
          _buildCriteriaCard(),
          _buildVentSettingsCard(),
          const SizedBox(height: 16),
          _buildSectionTitle("2. 藥物治療"),
          _buildDrugCard(),
          const SizedBox(height: 16),
          _buildSectionTitle("3. 救援治療 (Rescue)"),
          _buildRescueCard(),
        ],
      ),
    );
  }

  // ... (保留原有的 Widget 方法，如 _buildCalculatorCard, _buildCriteriaCard 等，內容不變)
  // 為了節省篇幅，這裡省略重複的 UI 代碼，請直接使用您原本 ards_screen.dart 的內容
  // 重點是：不需要變動邏輯

  // (請將原本 ards_screen.dart 剩下的 Widget 程式碼貼在這裡)
  Widget _buildCalculatorCard() {
    // ... 您的原始代碼
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

  Widget _buildCriteriaCard() {
    return const ExpansionTile(
      title: Text("診斷標準 (需符合4項)"),
      children: [
        ListTile(
          leading: Icon(Icons.timer, color: Colors.amber),
          title: Text("時效性: 1週內發生"),
        ),
        ListTile(
          leading: Icon(Icons.image, color: Colors.amber),
          title: Text("影像: 雙側肺浸潤"),
        ),
        ListTile(
          leading: Icon(Icons.water_drop, color: Colors.amber),
          title: Text("原因: 非單純心衰竭"),
        ),
        ListTile(
          leading: Icon(Icons.air, color: Colors.amber),
          title: Text("氧合: PaO2/FiO2 ≤ 300"),
        ),
      ],
    );
  }

  Widget _buildVentSettingsCard() {
    return const ExpansionTile(
      title: Text("Vent 設定目標"),
      initiallyExpanded: true,
      children: [
        ListTile(title: Text("Mode: Lung Protective Strategy")),
        ListTile(
          title: Text(
            "Plateau < 30 cmH2O",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        ListTile(title: Text("pH 7.25-7.45 (允許高碳酸血症)")),
        ListTile(title: Text("PaO2 55-80 mmHg 或 SpO2 88-95%")),
      ],
    );
  }

  Widget _buildDrugCard() {
    return const ExpansionTile(
      title: Text("鎮靜與肌鬆劑"),
      children: [
        ListTile(
          title: Text("Cisatracurium (Nimbex)"),
          subtitle: Text("P/F < 150 早期使用 (<48hr)\nLoading: 0.1-0.2 mg/kg"),
        ),
        ListTile(title: Text("Propofol"), subtitle: Text("RASS 目標: -3 ~ -4")),
      ],
    );
  }

  Widget _buildRescueCard() {
    return const ExpansionTile(
      title: Text("救援治療"),
      children: [
        ListTile(
          leading: Text("P/F<200", style: TextStyle(color: Colors.orange)),
          title: Text("High PEEP Test"),
        ),
        ListTile(
          leading: Text("P/F<150", style: TextStyle(color: Colors.red)),
          title: Text("Prone Position (俯臥)"),
        ),
        ListTile(
          leading: Text("P/F<80", style: TextStyle(color: Colors.purple)),
          title: Text("VV-ECMO"),
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
}
