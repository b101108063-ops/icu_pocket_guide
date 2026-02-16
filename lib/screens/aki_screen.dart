// lib/screens/aki_screen.dart
import 'package:flutter/material.dart';

class AkiScreen extends StatefulWidget {
  const AkiScreen({super.key});

  @override
  State<AkiScreen> createState() => _AkiScreenState();
}

class _AkiScreenState extends State<AkiScreen> {
  // FENa Calculator Controllers
  final TextEditingController _pCrController = TextEditingController();
  final TextEditingController _uCrController = TextEditingController();
  final TextEditingController _pNaController = TextEditingController();
  final TextEditingController _uNaController = TextEditingController();
  double? _fena;

  void _calculateFena() {
    double pCr = double.tryParse(_pCrController.text) ?? 0;
    double uCr = double.tryParse(_uCrController.text) ?? 0;
    double pNa = double.tryParse(_pNaController.text) ?? 0;
    double uNa = double.tryParse(_uNaController.text) ?? 0;

    if (pCr > 0 && uCr > 0 && pNa > 0 && uNa > 0) {
      setState(() {
        // FENa = (uNa * pCr) / (pNa * uCr) * 100
        _fena = (uNa * pCr) / (pNa * uCr) * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              color: Colors.yellow[900], // 使用深黃色/琥珀色代表腎臟
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "Dx & FENa"),
                  Tab(text: "Management"),
                  Tab(text: "RRT / CVVH"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDiagnosisTab(),
                  _buildManagementTab(),
                  _buildRrtTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab 1: Diagnosis & FENa ---
  Widget _buildDiagnosisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. KDIGO 診斷標準 (任一)"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.show_chart, color: Colors.yellowAccent),
                  title: Text(
                    "SCr 48hr 內上升 ≥ 0.3 mg/dL",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.yellowAccent,
                  ),
                  title: Text(
                    "SCr 7天內上升 ≥ 1.5 倍",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.water_drop, color: Colors.yellowAccent),
                  title: Text(
                    "Urine < 0.5 mL/kg/hr 持續 6hr",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "註: 尿量減少通常是早期徵兆",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. FENa 計算機 (鑑別診斷)"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInput(_pNaController, "P-Na")),
                    const SizedBox(width: 8),
                    Expanded(child: _buildInput(_pCrController, "P-Cr")),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildInput(_uNaController, "U-Na")),
                    const SizedBox(width: 8),
                    Expanded(child: _buildInput(_uCrController, "U-Cr")),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[800],
                    ),
                    onPressed: _calculateFena,
                    child: const Text(
                      "Calculate FENa",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (_fena != null) ...[
                  const Divider(),
                  Text(
                    "FENa: ${_fena!.toStringAsFixed(2)} %",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  Text(
                    _fena! < 1 ? "提示 Pre-renal (腎前性)" : "提示 ATN (腎性)",
                    style: TextStyle(
                      color: _fena! < 1 ? Colors.greenAccent : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "注意: 若有用利尿劑，FENa 會假性升高，改看 FEUrea (<35% 為腎前)",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("3. 鑑別診斷表"),
        _buildDiffTable(),
      ],
    );
  }

  Widget _buildDiffTable() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          _buildRow("指標", "Pre-renal", "Intrinsic (ATN)", isHeader: true),
          const Divider(color: Colors.white24, height: 1),
          _buildRow("FENa", "< 1%", "> 2%"),
          _buildRow("FEUrea", "< 35%", "> 50%"),
          _buildRow("U-Na", "< 20", "> 40"),
          _buildRow("U-Osm", "> 500 (濃)", "300-400 (等滲)"),
        ],
      ),
    );
  }

  // --- Tab 2: Management ---
  Widget _buildManagementTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 核心處置 (Core)"),
        _buildExpTile(
          "A. 液體復甦 (Fluid)",
          [
            "時機: 懷疑腎前性/低血容。",
            "方法: Crystalloid 500ml run 15min。",
            "目標: 觀察尿量與血壓反應。",
          ],
          Icons.water_drop,
          Colors.blueAccent,
        ),

        _buildExpTile(
          "B. 利尿劑測試 (Furosemide Stress Test)",
          [
            "時機: 體液足夠 (Euvolume) 但少尿。",
            "Naïve (未用過): 1 mg/kg IV bolus。",
            "User (用過): 1.5 mg/kg IV bolus。",
            "速算: Cr x 30 = 建議劑量 (mg)。",
            "判定: 2hr 尿量 < 200ml ⮕ Fail (考慮洗腎，勿盲目給藥)。",
          ],
          Icons.science,
          Colors.yellowAccent,
        ),

        _buildExpTile(
          "C. 升壓劑 (Vasopressors)",
          [
            "目標: MAP ≥ 65 mmHg (保腎臟灌流)。",
            "首選: Norepinephrine (Levophed)。",
            "禁忌: ❌ 低劑量 Dopamine (腎劑量) 無效且有害。",
          ],
          Icons.arrow_upward,
          Colors.redAccent,
        ),

        const SizedBox(height: 16),
        _buildHeader("2. 特殊情境"),
        _buildExpTile(
          "橫紋肌溶解 (Rhabdomyolysis)",
          [
            "診斷: CK > 5倍, Urine Myoglobin (+)。",
            "處置: 大量輸液 (目標 Urine > 200ml/hr)。",
            "選用: Bicarbonate 鹼化尿液 (pH > 6.5)。",
          ],
          Icons.fitness_center,
          Colors.orangeAccent,
        ),

        _buildExpTile(
          "肝腎症候群 (HRS)",
          [
            "藥物: Albumin 20-40g/day + Terlipressin 1mg Q4-6H。",
            "替代: Norepinephrine + Albumin。",
          ],
          Icons.local_hospital,
          Colors.greenAccent,
        ),

        _buildExpTile(
          "顯影劑腎病變 (CIN)",
          ["預防: 檢查前後 12hr給 N/S 1 ml/kg/hr (Hydration)。", "藥物: NAC 效果不明確但傷害小。"],
          Icons.contrast,
          Colors.grey,
        ),
      ],
    );
  }

  // --- Tab 3: RRT & CVVH ---
  Widget _buildRrtTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 洗腎適應症 (AEIOU)"),
        Card(
          color: Colors.red[900]!.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
          ),
          child: Column(
            children: const [
              ListTile(
                title: Text(
                  "A - Acidosis",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "pH < 7.1-7.2 (Metabolic)",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                title: Text(
                  "E - Electrolytes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "難治性 Hyper-K (>6.5 或心律不整)",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                title: Text(
                  "I - Intoxication",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "鋰鹽, 乙醇, 水楊酸",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                title: Text(
                  "O - Overload",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "肺水腫且利尿劑無效",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                title: Text(
                  "U - Uremia",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "心包膜炎, 腦病變",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. CVVH 醫令速查 (Orders)"),
        Card(
          color: Colors.blueGrey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "適用: 血流動力學不穩定 (Shock)",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Divider(color: Colors.white24),
                _buildOrderRow("Mode", "CVVH (過濾) or CVVHDF"),
                _buildOrderRow("Blood Flow (BFR)", "150 - 200 ml/min"),
                _buildOrderRow("Replacement", "體重 x 30-35 ml/hr"),
                _buildOrderRow("Fluid Removal", "休克設 0, 穩定後 50-100 ml/hr"),
                const Divider(color: Colors.white24),
                const Text(
                  "抗凝血 (Heparin):",
                  style: TextStyle(color: Colors.yellowAccent),
                ),
                _buildOrderRow("Priming", "2000 U ST"),
                _buildOrderRow(
                  "Maintenance",
                  "500 U/hr (1000U in 20ml run 10ml/hr)",
                ),
                const Text(
                  "注意: 出血風險者 (ICH/GI Bleed) 不加 Heparin",
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Helpers ---
  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.yellowAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
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

  Widget _buildRow(
    String col1,
    String col2,
    String col3, {
    bool isHeader = false,
  }) {
    TextStyle style = TextStyle(
      color: isHeader ? Colors.yellowAccent : Colors.white,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(col1, style: style)),
          Expanded(flex: 3, child: Text(col2, style: style)),
          Expanded(flex: 3, child: Text(col3, style: style)),
        ],
      ),
    );
  }

  Widget _buildOrderRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpTile(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        leading: Icon(icon, color: color),
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
}
