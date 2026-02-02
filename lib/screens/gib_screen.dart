// lib/screens/gib_screen.dart
import 'package:flutter/material.dart';

class GibScreen extends StatefulWidget {
  const GibScreen({super.key});

  @override
  State<GibScreen> createState() => _GibScreenState();
}

class _GibScreenState extends State<GibScreen> {
  // MTP 輸血計數器狀態
  int _rbcUnits = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Massive GI Bleeding"),
        backgroundColor: Colors.red[900], // 鮮血紅背景，強調緊急
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Airway & Initial (最優先)
          _buildCriticalActionCard(),

          const SizedBox(height: 16),

          // 2. MTP 輸血計數器 (互動工具)
          _buildSectionHeader("2. Transfusion Tracker (輸血計數)"),
          _buildTransfusionCounter(),

          const SizedBox(height: 16),

          // 3. 藥物治療
          _buildSectionHeader("3. Pharmacological Rx (止血藥物)"),
          _buildMedicationCard(),

          const SizedBox(height: 16),

          // 4. 特殊情況與處置
          _buildSectionHeader("4. Advanced & Special"),
          _buildAdvancedCard(),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 1. 關鍵處置卡片
  Widget _buildCriticalActionCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
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
                  "Initial Assessment (優先做)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.redAccent),
            _buildCheckItem("Protect Airway (插管?): 意識不清/嘔吐多"),
            _buildCheckItem("Large Bore IV: CVC, Double Lumen, 14G"),
            _buildCheckItem("Check Labs: CBC, PT/aPTT, DIC Profile"),
            _buildCheckItem("History: Warfarin? NOAC? Anti-platelet?"),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_box_outline_blank,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  // 2. 輸血計數器 (核心功能)
  Widget _buildTransfusionCounter() {
    bool needCalcium = _rbcUnits > 0 && _rbcUnits % 4 == 0;

    return Card(
      color: Colors.grey[900],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RBC Units Given",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "LPR / P-RBC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 32,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => setState(
                        () => _rbcUnits = (_rbcUnits > 0) ? _rbcUnits - 1 : 0,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        "$_rbcUnits",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        size: 32,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => setState(() => _rbcUnits++),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 提醒區域
          if (needCalcium)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.yellow[900],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_active, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "已輸 4U! 補充 1 amp Calcium!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          if (_rbcUnits > 2000 / 250) // 假設一袋 250ml, >8袋約2000ml
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.purple[900],
              child: const Text(
                "Massive Transfusion (>2000ml): 補 FFP + PLT",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // 3. 藥物清單
  Widget _buildMedicationCard() {
    return ExpansionTile(
      title: const Text(
        "藥物劑量速查",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: const Text("PPI, Glypressin, DDAVP"),
      initiallyExpanded: true,
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      children: [
        _buildDrugTile(
          "PPI (Nexium/Pantoloc)",
          "UGIB Standard",
          "Loading: 80mg IV st\nMaint: 8mg/hr pump run 72hr",
        ),
        _buildDrugTile(
          "Terlipressin (Glypressin)",
          "Variceal Bleeding",
          "Dose: 1 vial (1mg) IV Q6H",
        ),
        _buildDrugTile("Transamin", "General", "Full dose IV"),
        const Divider(color: Colors.grey),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "尿毒性出血 (Uremic Bleeding) / ESRD",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildDrugTile(
          "Desmopressin (DDAVP)",
          "Uremic Platelet Dysfunction",
          "16mcg + NS 50ml IV drip 30min",
        ),
        _buildDrugTile("Cryoprecipitate", "Fibrinogen補充", "Dose: 10 Units"),
      ],
    );
  }

  Widget _buildDrugTile(String name, String indication, String dose) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.lightBlueAccent,
        ),
      ),
      subtitle: Text("$indication\n$dose"),
      isThreeLine: true,
      dense: true,
    );
  }

  // 4. 進階處置
  Widget _buildAdvancedCard() {
    return Card(
      color: Colors.black45,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.redAccent),
            title: const Text("Upper GI Bleeding"),
            subtitle: const Text(
              "• Consult GI for PES (Endoscopy)\n• SB Tube if uncontrollable",
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.radio_button_checked,
              color: Colors.redAccent,
            ),
            title: const Text("Lower GI Bleeding"),
            subtitle: const Text(
              "• Consult Radio for CTA / TAE (Embolization)",
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[800],
            child: const Text(
              "💡 Tip: 開立 Massive UGI bleeding 組套",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
