// lib/screens/sedation_screen.dart
import 'package:flutter/material.dart';

class SedationScreen extends StatefulWidget {
  const SedationScreen({super.key});

  @override
  State<SedationScreen> createState() => _SedationScreenState();
}

class _SedationScreenState extends State<SedationScreen> {
  // 計算機狀態變數
  final TextEditingController _weightController = TextEditingController();
  double _weight = 60.0;

  // Propofol 計算
  double _propofolDose = 1.0; // mg/kg/hr

  // Precedex 計算
  double _precedexDose = 0.5; // mcg/kg/hr

  @override
  void initState() {
    super.initState();
    _weightController.text = "60"; // 預設體重
    _weightController.addListener(() {
      setState(() {
        _weight = double.tryParse(_weightController.text) ?? 60.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CNS: Sedation & Delirium")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 頂部：共用體重輸入 (給下面的計算機用)
          _buildWeightInput(),
          const SizedBox(height: 16),

          // Step 1: 止痛
          _buildStepHeader("Step 1: Analgesia (先止痛)", Colors.pinkAccent),
          _buildPainCard(),

          const SizedBox(height: 16),

          // Step 2: 鎮靜
          _buildStepHeader("Step 2: Sedation (再鎮靜)", Colors.blueAccent),
          _buildSedationProtocolCard(), // BZD 階梯
          const SizedBox(height: 8),
          _buildAdvancedSedationCalc(), // Propofol & Precedex 計算機

          const SizedBox(height: 16),

          // Step 3: 譫妄
          _buildStepHeader("Step 3: Delirium (後譫妄)", Colors.purpleAccent),
          _buildDeliriumCard(),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildWeightInput() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.monitor_weight, color: Colors.grey),
            const SizedBox(width: 12),
            const Text("病人體重 (kg): ", style: TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // Step 1: Pain Control
  Widget _buildPainCard() {
    return ExpansionTile(
      title: const Text(
        "Fentanyl Protocol",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text("NRS > 5 或 BPS > 9 時使用"),
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      children: [
        ListTile(
          title: const Text("評估工具"),
          subtitle: const Text(
            "清醒: NRS (0-10)\n插管: BPS (3-12) - 表情/上肢/Vent配合度",
          ),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.water_drop, color: Colors.pinkAccent),
          title: const Text("泡法 (Preparation)"),
          subtitle: const Text("1000 mcg 泡在 100ml NS\n(濃度: 10 mcg/ml)"),
        ),
        ListTile(
          leading: const Icon(Icons.bolt, color: Colors.pinkAccent),
          title: const Text("劑量 (Dose)"),
          subtitle: const Text(
            "Bolus: 5 ml (50 mcg)\nInfusion: 5 ml/hr (50 mcg/hr)",
          ),
        ),
      ],
    );
  }

  // Step 2-1: Basic Sedation (BZD)
  Widget _buildSedationProtocolCard() {
    return ExpansionTile(
      title: const Text("BZD Protocol (Lorazepam/Midazolam)"),
      subtitle: const Text("目標: RASS -2 ~ +1 (ARDS: -3 ~ -4)"),
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      children: [
        ListTile(
          title: const Text("Intermittent Bolus (優先)"),
          subtitle: const Text(
            "若 RASS > 0:\nLorazepam 2mg IV q15m\nMidazolam 5mg IV q15m",
          ),
        ),
        const Divider(height: 1),
        const ListTile(
          title: Text("Continuous Infusion (1hr後仍躁動)"),
          subtitle: Text(
            "Lorazepam: 2mg/4ml (Rate 1ml/hr)\n"
            "Dormicum: 15mg/3ml (Rate 1ml/hr)",
          ),
        ),
      ],
    );
  }

  // Step 2-2: Advanced Calculator (Propofol / Precedex)
  Widget _buildAdvancedSedationCalc() {
    // Propofol: 1% (10mg/ml). Rate = (Dose * W) / 10
    double propofolRate = (_propofolDose * _weight) / 10;

    // Precedex: 4mcg/ml. Rate = (Dose * W) / 4
    double precedexRate = (_precedexDose * _weight) / 4;

    return Card(
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "特殊藥物計算機 (Special Agents)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          // Propofol Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Propofol (1%)",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${propofolRate.toStringAsFixed(1)} ml/hr",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "泡法: 原液 10mg/ml",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Text("Dose: "),
                    Expanded(
                      child: Slider(
                        value: _propofolDose,
                        min: 0.3,
                        max: 3.0,
                        divisions: 27,
                        label: _propofolDose.toStringAsFixed(1),
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (v) => setState(() => _propofolDose = v),
                      ),
                    ),
                    Text("${_propofolDose.toStringAsFixed(1)} mg/kg/hr"),
                  ],
                ),
                if (_propofolDose > 2.5) // 簡單的警示
                  const Text(
                    "注意: 高劑量需監測 PRIS (酸中毒/高血鉀)",
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Precedex Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Precedex",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${precedexRate.toStringAsFixed(1)} ml/hr",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "泡法: 200mcg/2ml + 48ml NS (4mcg/ml)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Text("Dose: "),
                    Expanded(
                      child: Slider(
                        value: _precedexDose,
                        min: 0.2,
                        max: 1.5,
                        divisions: 13,
                        label: _precedexDose.toStringAsFixed(1),
                        activeColor: Colors.tealAccent,
                        onChanged: (v) => setState(() => _precedexDose = v),
                      ),
                    ),
                    Text("${_precedexDose.toStringAsFixed(1)} mcg/kg/hr"),
                  ],
                ),
                const Text(
                  "注意: 易低血壓/心跳慢。不建議 Loading。",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Delirium
  Widget _buildDeliriumCard() {
    return ExpansionTile(
      title: const Text("CAM-ICU & Treatment"),
      subtitle: const Text("鎮靜後意識仍混亂 / 日夜顛倒"),
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CAM-ICU 診斷標準:",
                style: TextStyle(color: Colors.purpleAccent),
              ),
              Text("必要: (1) 急性改變/波動 + (2) 注意力不集中"),
              Text("加選: (3) RASS不為0 或 (4) 思考混亂"),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              Text("藥物治療:", style: TextStyle(color: Colors.purpleAccent)),
              Text("1. Haloperidol: 5mg IM q30m PRN (Max 35mg)"),
              Text("2. Seroquel: 25mg PO BID"),
            ],
          ),
        ),
      ],
    );
  }
}
