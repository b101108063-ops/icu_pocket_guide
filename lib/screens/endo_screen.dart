// lib/screens/endo_screen.dart
import 'package:flutter/material.dart';

class EndoScreen extends StatefulWidget {
  const EndoScreen({super.key});

  @override
  State<EndoScreen> createState() => _EndoScreenState();
}

class _EndoScreenState extends State<EndoScreen> {
  // Calculators State
  final TextEditingController _naController = TextEditingController();
  final TextEditingController _gluController = TextEditingController();
  double? _correctedNa;

  final TextEditingController _naAgController = TextEditingController();
  final TextEditingController _clAgController = TextEditingController();
  final TextEditingController _hco3AgController = TextEditingController();
  double? _anionGap;

  @override
  void dispose() {
    _naController.dispose();
    _gluController.dispose();
    _naAgController.dispose();
    _clAgController.dispose();
    _hco3AgController.dispose();
    super.dispose();
  }

  void _calcCorrectedNa() {
    double na = double.tryParse(_naController.text) ?? 0;
    double glu = double.tryParse(_gluController.text) ?? 0;
    if (na > 0 && glu > 0) {
      setState(() {
        // Formula: Measured Na + 1.6 * (Glucose - 100) / 100
        _correctedNa = na + 1.6 * (glu - 100) / 100;
      });
    }
  }

  void _calcAnionGap() {
    double na = double.tryParse(_naAgController.text) ?? 0;
    double cl = double.tryParse(_clAgController.text) ?? 0;
    double hco3 = double.tryParse(_hco3AgController.text) ?? 0;
    if (na > 0 && cl > 0 && hco3 > 0) {
      setState(() {
        // Formula: Na - (Cl + HCO3)
        _anionGap = na - (cl + hco3);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              color: Colors.green[800], // 內分泌用綠色
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "DKA / HHS Protocol"),
                  Tab(text: "Calculators (Na/AG)"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [_buildProtocolTab(), _buildCalculatorTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab 1: Protocol ---
  Widget _buildProtocolTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. DKA vs HHS 鑑別"),
        _buildDiffTable(),
        const SizedBox(height: 16),

        _buildHeader("2. 核心治療 (VIP Protocol)"),
        _buildVipSection(),
        const SizedBox(height: 16),

        _buildHeader("3. 酒精性酮酸中毒 (AKA)"),
        _buildAkaCard(),
        const SizedBox(height: 16),

        _buildHeader("4. 監測與脫離 (Resolution)"),
        _buildResolutionCard(),
        const SizedBox(height: 30),
      ],
    );
  }

  // --- Tab 2: Calculators ---
  Widget _buildCalculatorTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 校正鈉離子 (Corrected Na)"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "因高血糖導致稀釋性低血鈉",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildInput(_naController, "Na (mEq/L)")),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInput(_gluController, "Glucose (mg/dL)"),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _calcCorrectedNa,
                  child: const Text(
                    "Calculate",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_correctedNa != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "Corrected Na: ${_correctedNa!.toStringAsFixed(1)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. 陰離子間隙 (Anion Gap)"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Formula: Na - (Cl + HCO3)",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildInput(_naAgController, "Na")),
                    const SizedBox(width: 8),
                    Expanded(child: _buildInput(_clAgController, "Cl")),
                    const SizedBox(width: 8),
                    Expanded(child: _buildInput(_hco3AgController, "HCO3")),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _calcAnionGap,
                  child: const Text(
                    "Calculate AG",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_anionGap != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Text(
                          "AG: ${_anionGap!.toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _anionGap! > 12
                                ? Colors.redAccent
                                : Colors.greenAccent,
                          ),
                        ),
                        Text(
                          _anionGap! > 12
                              ? "High Anion Gap Acidosis"
                              : "Normal Gap",
                          style: TextStyle(
                            color: _anionGap! > 12
                                ? Colors.redAccent
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Widgets for Protocol ---
  Widget _buildDiffTable() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          _buildTableRow("特徵", "DKA", "HHS", isHeader: true),
          const Divider(color: Colors.white24, height: 1),
          _buildTableRow("Onset", "快速 (<24h)", "緩慢 (數天)"),
          _buildTableRow("Glucose", "> 250 (可正常)", "> 600"),
          _buildTableRow("pH", "≤ 7.30 (酸)", "> 7.30"),
          _buildTableRow("Ketone", "陽性 (+)", "微量 / (-)"),
          _buildTableRow("AG", "> 12 (High)", "Variable"),
          _buildTableRow("Osm", "Variable", "> 320 (高)"),
          _buildTableRow("意識", "清醒/嗜睡", "昏迷/改變"),
        ],
      ),
    );
  }

  Widget _buildVipSection() {
    return Column(
      children: [
        _buildStepCard("Step 1: Volume (液體復甦)", Colors.blueAccent, [
          "最優先！目標恢復循環容積。",
          "首選: N/S 或 Ringer's。首小時 1000ml。",
          "換水時機: 血糖降至 250 (DKA) / 300 (HHS) 時，改 D5W + 0.45% NaCl。",
          "目標: 維持血糖 150-200，避免低血糖。",
        ]),

        _buildStepCard("Step 2: Potassium (鉀離子)", Colors.yellowAccent, [
          "決定能否給 Insulin 的關鍵！",
          "K < 3.3: ⛔ 禁止給 Insulin！先補 KCL 20-40 mEq/hr。",
          "K 3.3-5.2: 補 KCL 20-30 mEq/L + Insulin。",
          "K > 5.2: 不補鉀，每 2hr 追蹤。",
        ]),
        _buildStepCard("Step 3: Insulin (胰島素)", Colors.redAccent, [
          "RI Infusion: 0.1 U/kg/hr。",
          "目標: 血糖每小時降 50-75 mg/dL。",
          "MICU 建議: 雙幫浦 (含糖點滴 + RI pump) 以維持血糖並消除酮體。",
        ]),
        _buildStepCard("Step 4: Bicarbonate", Colors.grey, [
          "原則: 通常不需要。",
          "適應症: pH < 6.9 且嚴重休克/高血鉀。",
        ]),
      ],
    );
  }

  Widget _buildAkaCard() {
    return Card(
      color: Colors.purple.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "病史: 酗酒 + 嘔吐 + 飢餓",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "特徵: 血糖正常/偏低，High AG 酸中毒，尿酮體可能(-)。",
              style: TextStyle(color: Colors.white70),
            ),
            Divider(color: Colors.white24),
            Text(
              "治療: D5NS + Thiamine (B1)。",
              style: TextStyle(
                color: Colors.yellowAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "注意: 葡萄糖可抑制酮體，不需要打胰島素。",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "DKA 緩解標準",
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "血糖 < 200 加上:\n1. AG < 12 (閉合)\n2. pH > 7.3\n3. HCO3 ≥ 15",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            title: const Text(
              "轉換皮下注射 (Transition)",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "關鍵: 打完 SC Insulin 後，IV Insulin 需續用 1-2 小時再停，防反彈。",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String c1,
    String c2,
    String c3, {
    bool isHeader = false,
  }) {
    TextStyle style = TextStyle(
      color: isHeader ? Colors.greenAccent : Colors.white,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(c1, style: style)),
          Expanded(
            flex: 3,
            child: Text(
              c2,
              style: style.copyWith(
                color: isHeader ? null : Colors.orangeAccent,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              c3,
              style: style.copyWith(
                color: isHeader ? null : Colors.purpleAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String title, Color color, List<String> items) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(color: Colors.white24),
            ...items.map(
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $i",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
