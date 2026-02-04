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

  // State 變數
  final TextEditingController _rrController = TextEditingController();
  final TextEditingController _vtController = TextEditingController();
  double? _rsbi;

  final TextEditingController _vtiController = TextEditingController();
  final TextEditingController _vteController = TextEditingController();
  double? _leakVolume;
  double? _leakPercent;

  final TextEditingController _weightController = TextEditingController();
  double _weight = 60.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _weightController.text = "60";
    _weightController.addListener(() {
      setState(() => _weight = double.tryParse(_weightController.text) ?? 60.0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 計算邏輯
  void _calculateRsbi() {
    double rr = double.tryParse(_rrController.text) ?? 0;
    double vt = double.tryParse(_vtController.text) ?? 0;
    if (vt > 0) setState(() => _rsbi = rr / (vt / 1000));
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
        title: const Text("Vent & ICU Procedures"),
        backgroundColor: Colors.teal[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent,
          tabs: const [
            Tab(text: "Weaning"), // 脫離
            Tab(text: "Trouble"), // 異常波形與處置
            Tab(text: "Lines/CVVH"), // 管路與洗腎
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWeaningTab(),
          _buildTroubleshootingTab(),
          _buildLinesTab(),
        ],
      ),
    );
  }

  // --- Tab 1: Weaning (RSBI & Cuff Leak) ---
  Widget _buildWeaningTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. RSBI Calculator (脫離指標)"),
        Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
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
        _buildSectionHeader("2. Cuff Leak Test (拔管前)"),
        Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInput(_vtiController, "Vti (吸氣)")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInput(_vteController, "Vte (氣囊放掉)")),
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
                  Text(
                    "Leak: ${_leakVolume!.toStringAsFixed(0)} ml (${_leakPercent!.toStringAsFixed(1)}%)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (_leakVolume! > 110 || _leakPercent! > 12)
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  if (_leakVolume! <= 110)
                    const Text(
                      "Fail! Rx: Solu-Medrol 20mg IV Q4H x 4 doses",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Tab 2: Troubleshooting (Merged Auto-PEEP & Waveforms) ---
  Widget _buildTroubleshootingTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. Auto-PEEP (Air Trapping)"),
        Card(
          color: Colors.red[900]!.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      "危急處置 (Desaturation/Hypotension)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.redAccent),
                Text(
                  "1. Disconnect Ventilator (拔管路, Air release)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("2. Ambu bagging & Suction"),
                Text("3. 設定調整: 降 Rate, 降 Ti, 給支擴劑"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader("2. 波形異常判讀 (Waveforms)"),
        const ListTile(
          leading: Icon(Icons.waves, color: Colors.tealAccent),
          title: Text("Scooping Sign (凹陷)"),
          subtitle: Text("Flow-Volume curve 吐氣端凹陷。\n代表：呼吸道阻力增加 (Asthma/COPD)。"),
        ),
        const ListTile(
          leading: Icon(Icons.loop, color: Colors.tealAccent),
          title: Text("Auto-PEEP Loop"),
          subtitle: Text(
            "Flow-Volume loop 吐氣端「回不了原點」。\n處置：請 RT 測量 Intrinsic PEEP。",
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader("3. Pneumothorax (氣胸)"),
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
      ],
    );
  }

  // --- Tab 3: Lines & CVVH ---
  Widget _buildLinesTab() {
    double cvvhReplacement = _weight * 35;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. CVVH 計算 (35ml/kg)"),
        Card(
          color: Colors.blueGrey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
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
                _buildOrderRow(
                  "Replacement",
                  "${cvvhReplacement.toInt()} ml/hr",
                ),
                _buildOrderRow("Heparin", "5 ml/hr (1000u/20ml)"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader("2. Flotrac / A-line"),
        const Card(
          color: Colors.black45,
          child: Column(
            children: [
              ListTile(
                title: Text("SVV > 10-12%"),
                subtitle: Text(
                  "欠水 (Hypovolemia) -> Challenge fluid",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
              ListTile(
                title: Text("Over-damping (波形鈍)"),
                subtitle: Text("氣泡、折到 -> SBP 被低估"),
              ),
              ListTile(
                title: Text("Under-damping (震盪大)"),
                subtitle: Text("管路長、心跳快 -> SBP 被高估"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helpers
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

  Widget _buildInput(TextEditingController c, String label) {
    return TextField(
      controller: c,
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
