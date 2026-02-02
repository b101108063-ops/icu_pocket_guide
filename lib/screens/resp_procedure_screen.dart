// lib/screens/resp_procedure_screen.dart
import 'package:flutter/material.dart';

class RespProcedureScreen extends StatefulWidget {
  const RespProcedureScreen({super.key});

  @override
  State<RespProcedureScreen> createState() => _RespProcedureScreenState();
}

class _RespProcedureScreenState extends State<RespProcedureScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Weaning Calculator State
  final TextEditingController _rrController = TextEditingController();
  final TextEditingController _vtController = TextEditingController(); // ml
  double? _rsbi;

  // Cuff Leak State
  final TextEditingController _vtiController = TextEditingController();
  final TextEditingController _vteController = TextEditingController();
  double? _leakVolume;
  double? _leakPercent;

  // CVVH State
  final TextEditingController _weightController = TextEditingController();
  double _weight = 60.0;

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

  void _calculateRsbi() {
    double rr = double.tryParse(_rrController.text) ?? 0;
    double vt = double.tryParse(_vtController.text) ?? 0; // ml
    if (vt > 0) {
      setState(() {
        _rsbi = rr / (vt / 1000); // RSBI formula uses Liters
      });
    }
  }

  void _calculateLeak() {
    double vti = double.tryParse(_vtiController.text) ?? 0;
    double vte = double.tryParse(_vteController.text) ?? 0;
    if (vti > 0) {
      setState(() {
        _leakVolume = vti - vte;
        _leakPercent = (_leakVolume! / vti) * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vent & Procedures"),
        backgroundColor: Colors.teal[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent,
          tabs: const [
            Tab(text: "Weaning"),
            Tab(text: "Trouble"),
            Tab(text: "Lines/CVVH"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildWeaningTab(), _buildTroubleTab(), _buildLinesTab()],
      ),
    );
  }

  // --- Tab 1: Weaning Calculator ---
  Widget _buildWeaningTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. RSBI Calculator (脫離指標)"),
        Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInput(_rrController, "RR (bpm)")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInput(_vtController, "Vt (ml)")),
                    IconButton(
                      icon: const Icon(
                        Icons.calculate,
                        color: Colors.tealAccent,
                        size: 32,
                      ),
                      onPressed: _calculateRsbi,
                    ),
                  ],
                ),
                if (_rsbi != null) ...[
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("RSBI Score:", style: TextStyle(fontSize: 16)),
                      Text(
                        _rsbi!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _rsbi! < 105
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _rsbi! < 105 ? "Pass (< 105)" : "Fail (> 105)",
                    style: TextStyle(
                      color: _rsbi! < 105 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. Cuff Leak Test (拔管前測試)"),
        Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInput(_vtiController, "Vti (吸氣)")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInput(_vteController, "Vte (氣囊放掉後)")),
                    IconButton(
                      icon: const Icon(
                        Icons.calculate,
                        color: Colors.tealAccent,
                        size: 32,
                      ),
                      onPressed: _calculateLeak,
                    ),
                  ],
                ),
                if (_leakVolume != null) ...[
                  const Divider(),
                  Text("Leak Volume: ${_leakVolume!.toStringAsFixed(0)} ml"),
                  Text(
                    "Leak Percent: ${_leakPercent!.toStringAsFixed(1)} %",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (_leakVolume! > 110 || _leakPercent! > 12)
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_leakVolume! <= 110)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.withOpacity(0.2),
                      child: const Text(
                        "Fail! Rx: Solu-Medrol 20mg IV Q4H x 4 doses",
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Tab 2: Troubleshooting (Red Flags) ---
  Widget _buildTroubleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. Auto-PEEP (Air Trapping)"),
        Card(
          color: Colors.red[900]!.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "徵象: Flow loop 吐氣回不了原點 / BP Drop",
                  style: TextStyle(color: Colors.white70),
                ),
                const Divider(color: Colors.redAccent),
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "危急處置 (Desaturation/Hypotension)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "1. Disconnect Ventilator (Air release)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text("2. Ambu bagging & Suction"),
                const Text("3. 調整: 降 Rate, 降 Ti, 給支擴劑"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. Pneumothorax (氣胸)"),
        const Card(
          color: Colors.black45,
          child: ListTile(
            leading: Icon(Icons.air, color: Colors.cyanAccent),
            title: Text("Needle Decompression"),
            subtitle: Text(
              "位置: Mid-axilla line 5th ICS\nEcho: Barcode Sign / No Sliding",
            ),
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("3. Echo 判讀口訣"),
        const Card(
          color: Colors.black45,
          child: Column(
            children: [
              ListTile(
                title: Text("A-line"),
                subtitle: Text("正常 (氣體)"),
                dense: true,
              ),
              ListTile(
                title: Text("B-line (Comet tail)"),
                subtitle: Text("肺水腫 (Lung Edema)"),
                dense: true,
              ),
              ListTile(
                title: Text("D-shape LV"),
                subtitle: Text("Pulmonary Embolism (PE)"),
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Tab 3: Procedures & Lines ---
  Widget _buildLinesTab() {
    // CVVH 計算
    double cvvhReplacement = _weight * 35;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. CVVH Calculator
        _buildSectionHeader("1. CVVH / CVVHDF 劑量"),
        Card(
          color: Colors.blueGrey[900],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monitor_weight),
                    const SizedBox(width: 8),
                    const Text("體重: "),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(" kg"),
                  ],
                ),
                const Divider(),
                const Text(
                  "Suggested Orders:",
                  style: TextStyle(color: Colors.cyanAccent),
                ),
                const SizedBox(height: 8),
                _buildOrderRow(
                  "CVVH Replacement (35ml/kg)",
                  "${cvvhReplacement.toInt()} ml/hr",
                ),
                _buildOrderRow(
                  "Heparin Maintenance",
                  "Run 5 ml/hr (1000u in 20ml)",
                ),
                const Text(
                  "註: 若出血傾向勿用 Heparin",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. Flotrac / A-line 判讀"),
        const Card(
          color: Colors.black45,
          child: Column(
            children: [
              ListTile(
                title: Text("SVV > 10-12%"),
                subtitle: Text(
                  "Hypovolemia (欠水) -> 給水",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
              ListTile(
                title: Text("A-line Over-damping (波形鈍)"),
                subtitle: Text("氣泡、折到 -> SBP 低估"),
              ),
              ListTile(
                title: Text("A-line Under-damping (震盪大)"),
                subtitle: Text("管路過長、心跳快 -> SBP 高估"),
              ),
            ],
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

  Widget _buildInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildOrderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.yellowAccent,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
