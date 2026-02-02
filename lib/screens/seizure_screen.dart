// lib/screens/seizure_screen.dart
import 'package:flutter/material.dart';

class SeizureScreen extends StatefulWidget {
  const SeizureScreen({super.key});

  @override
  State<SeizureScreen> createState() => _SeizureScreenState();
}

class _SeizureScreenState extends State<SeizureScreen> {
  final TextEditingController _weightController = TextEditingController();
  double _weight = 60.0; // 預設體重

  @override
  void initState() {
    super.initState();
    _weightController.text = "60";
    _weightController.addListener(() {
      setState(() {
        _weight = double.tryParse(_weightController.text) ?? 60.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Epilepticus Protocol"),
        backgroundColor: Colors.purple[900], // 癲癇神經相關用紫色
      ),
      body: Column(
        children: [
          // 頂部固定：體重輸入 (所有藥物計算的基礎)
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.monitor_weight, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  "病人體重 (kg): ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
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

          // 下方捲動區：治療流程
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Phase 1
                _buildPhaseHeader(
                  "Phase 1: 0-10 min (Stop Seizure)",
                  Colors.redAccent,
                ),
                _buildInitialStabilizationCard(),
                _buildBzdCard(),

                const SizedBox(height: 16),

                // Phase 2
                _buildPhaseHeader(
                  "Phase 2: 10-30 min (Loading AEDs)",
                  Colors.orangeAccent,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "若 BZD 無效，儘速 Loading 下列藥物 (擇一)",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                _buildAedCard(
                  "Depakine (Valproic acid)",
                  20,
                  30,
                  "Rate: 100 mg/min",
                  note: "手冊建議: 1200-1600mg (3-4 vials)",
                ),
                _buildAedCard(
                  "Keppra (Levetiracetam)",
                  20,
                  60,
                  "Rate: > 15 min",
                  note: "手冊建議: 1000mg (2 vials)",
                ),
                _buildDilantinCard(), // Dilantin 有特殊警示，獨立寫

                const SizedBox(height: 16),

                // Phase 3
                _buildPhaseHeader(
                  "Phase 3: 30-90 min (Refractory)",
                  Colors.purpleAccent,
                ),
                _buildRefractoryCard(),

                const SizedBox(height: 16),

                // Work-up
                _buildPhaseHeader(
                  "4. Post-Stabilization Work-up",
                  Colors.blueAccent,
                ),
                const Card(
                  color: Colors.black45,
                  child: ListTile(
                    leading: Icon(Icons.scanner, color: Colors.blueAccent),
                    title: Text("Brain CT"),
                    subtitle: Text("待病人 Stable 後，尋找病因 (ICH, Tumor, Stroke)"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildPhaseHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Row(
        children: [
          Icon(Icons.timer, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Phase 1: ABC & Labs
  Widget _buildInitialStabilizationCard() {
    return Card(
      color: Colors.grey[900],
      child: const ExpansionTile(
        title: Text(
          "ABC & Labs (優先處置)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: true,
        children: [
          ListTile(
            leading: Icon(Icons.air, color: Colors.cyanAccent),
            title: Text("Airway / Breathing / Circulation"),
          ),
          ListTile(
            leading: Icon(Icons.bloodtype, color: Colors.redAccent),
            title: Text("Check Sugar & Electrolytes"),
          ),
          ListTile(
            leading: Icon(Icons.medication, color: Colors.orangeAccent),
            title: Text("給予 Thiamine + D50W (若低血糖)"),
          ),
        ],
      ),
    );
  }

  // Phase 1: BZD
  Widget _buildBzdCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.redAccent),
      ),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "First Line: Benzodiazepines",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text("目標：終止發作"),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              "Ativan (Lorazepam)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
            ),
            subtitle: const Text("2 - 4 mg IV (Rate: 2mg/min)"),
            trailing: Text(
              "首選",
              style: TextStyle(
                color: Colors.green[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ListTile(
            title: Text(
              "Dormicum (Midazolam)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
            ),
            subtitle: Text("10 mg IM (若打不到血管)"),
          ),
        ],
      ),
    );
  }

  // Phase 2: AED Calculator
  Widget _buildAedCard(
    String name,
    double minDose,
    double maxDose,
    String rate, {
    String? note,
  }) {
    // 自動計算劑量範圍
    int low = (_weight * minDose).toInt();
    int high = (_weight * maxDose).toInt();

    return Card(
      color: Colors.grey[850],
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.lightBlueAccent,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note != null)
              Text(
                note,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            const SizedBox(height: 4),
            Text(rate, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Loading Dose",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                "$low - $high mg",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dilantin 特別卡片 (警告多)
  Widget _buildDilantinCard() {
    int dose = (_weight * 20).toInt(); // 20mg/kg

    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "Dilantin (Phenytoin)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
          ),
        ),
        subtitle: const Text("Rate < 50 mg/min (注意血壓/心律)"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Loading",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                "$dose mg",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.redAccent),
            title: Text(
              "警告: 推太快會低血壓/心律不整",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ListTile(
            title: Text("Fosphenytoin (替代藥物)"),
            subtitle: Text("20 mg PE/kg (Rate 150 mg/min) - 較安全"),
          ),
        ],
      ),
    );
  }

  // Phase 3: Refractory
  Widget _buildRefractoryCard() {
    return Card(
      color: Colors.purple[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.purpleAccent),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.purpleAccent.withOpacity(0.2),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_services, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "需插管 (Intubation) 並使用 Pump",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _buildPumpRow(
            "Midazolam Pump",
            "Load: 0.2 mg/kg",
            "Run: 0.2 - 0.6 mg/kg/hr",
          ),
          const Divider(),
          _buildPumpRow(
            "Propofol Pump",
            "Load: 2 mg/kg",
            "Run: 2 - 5 mg/kg/hr",
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "注意: Propofol 易造成低血壓",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPumpRow(String name, String load, String run) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.purpleAccent,
        ),
      ),
      subtitle: Text("$load\n$run"),
      isThreeLine: true,
    );
  }
}
