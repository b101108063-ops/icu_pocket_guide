// lib/screens/pe_screen.dart
import 'package:flutter/material.dart';

class PeScreen extends StatefulWidget {
  const PeScreen({super.key});

  @override
  State<PeScreen> createState() => _PeScreenState();
}

class _PeScreenState extends State<PeScreen> {
  // 風險分級變數
  bool _isShock = false; // BP < 90 or Vasopressors
  bool _isRvDysfunction = false; // Echo or CT
  bool _isTroponinPos = false; // High Troponin or BNP

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 風險分級計算機 (核心功能)
          _buildHeader("1. 風險分級計算機 (Risk Stratification)"),
          _buildRiskCalculator(),
          const SizedBox(height: 16),

          // 2. 診斷與 Bedside Echo
          _buildHeader("2. 診斷與 Bedside Echo"),
          _buildDiagnosisCard(),
          const SizedBox(height: 16),

          // 3. 治療：溶栓與抗凝血
          _buildHeader("3. 藥物治療 (Thrombolysis & Anticoagulation)"),
          _buildTreatmentSection(),
          const SizedBox(height: 16),

          // 4. 救援與珍珠
          _buildHeader("4. 救援治療 & 臨床珍珠"),
          _buildRescueSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 風險計算機 ---
  Widget _buildRiskCalculator() {
    // 判斷邏輯 (ESC Guidelines)
    String riskLevel = "Low Risk";
    Color riskColor = Colors.greenAccent;
    String strategy = "口服抗凝血劑 (DOACs)";

    if (_isShock) {
      riskLevel = "High Risk (Massive)";
      riskColor = Colors.redAccent;
      strategy = "溶栓治療 (Thrombolysis)\n+ Heparin (UFH)";
    } else if (_isRvDysfunction && _isTroponinPos) {
      riskLevel = "Intermediate-High (Submassive)";
      riskColor = Colors.orangeAccent;
      strategy = "LMWH (首選) 或 UFH\n密切監測，若惡化則救援性溶栓";
    } else if (_isRvDysfunction || _isTroponinPos) {
      riskLevel = "Intermediate-Low";
      riskColor = Colors.yellowAccent;
      strategy = "LMWH 或 DOACs";
    }

    return Card(
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              "Shock / Hypotension",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "SBP < 90 mmHg 或需升壓劑",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _isShock,
            activeColor: Colors.redAccent,
            onChanged: (v) => setState(() => _isShock = v),
          ),
          SwitchListTile(
            title: const Text(
              "RV Dysfunction",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "Echo (RV擴大/D-shape) 或 CT",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _isRvDysfunction,
            activeColor: Colors.orangeAccent,
            onChanged: (v) => setState(() => _isRvDysfunction = v),
          ),
          SwitchListTile(
            title: const Text(
              "Positive Biomarkers",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "Troponin (+) 或 BNP 升高",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _isTroponinPos,
            activeColor: Colors.orangeAccent,
            onChanged: (v) => setState(() => _isTroponinPos = v),
          ),
          const Divider(color: Colors.white24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: riskColor.withOpacity(0.2),
            child: Column(
              children: [
                Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: riskColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strategy,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. 診斷與 Echo ---
  Widget _buildDiagnosisCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "Bedside Echo 徵象 (休克時)",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          _buildBullet("D-shape LV", "右室壓力高，將室中膈壓向左室 (短軸切面)。"),

          _buildBullet(
            "McConnell's Sign",
            "RV free wall 不動，但 Apex 收縮正常 (特異性高)。",
          ),
          _buildBullet("Mobile Thrombi", "右心系統可見飄動血栓。"),
          _buildBullet("DVT Scan", "下肢靜脈壓不扁 (Non-compressible)。"),
          const Divider(color: Colors.white24),
          _buildBullet("CTPA", "黃金標準 (Gold Standard)。"),
          _buildBullet("D-dimer", "陰性預測值高，但住院病人常偽陽性。"),
        ],
      ),
    );
  }

  // --- 3. 治療 ---
  Widget _buildTreatmentSection() {
    return Column(
      children: [
        _buildExpTile(
          "A. 溶栓治療 (Thrombolysis)",
          [
            "適應症: High Risk (Massive) 且無禁忌症。",
            "標準劑量 (tPA): 100 mg IV infusion over 2hr。",
            "急救劑量 (Cardiac Arrest): 50 mg IV bolus (或 0.6 mg/kg over 15min)。",
            "禁忌: 活動性出血、近期中風/手術。",
            "風險: 嚴重出血 (10%)、顱內出血 (1-2%)。",
          ],
          Icons.warning,
          Colors.redAccent,
        ),

        _buildExpTile(
          "B. 抗凝血 (Anticoagulation)",
          [
            "UFH (Heparin): High Risk 首選 (可隨時停)。\n   Bolus 80 U/kg -> Infusion 18 U/kg/hr。\n   目標 aPTT 1.5-2.5倍。",
            "LMWH (Clexane): Intermediate 首選 (效果穩)。\n   1 mg/kg SC Q12H。\n   (腎功能差 CrCl<30 需減量或改 UFH)。",
            "DOACs (Eliquis/Xarelto): Low Risk / 出院。\n   Eliquis: 10mg BID x7d -> 5mg BID。\n   Xarelto: 15mg BID x3w -> 20mg QD。",
          ],
          Icons.bloodtype,
          Colors.blueAccent,
        ),
      ],
    );
  }

  // --- 4. 救援與珍珠 ---
  Widget _buildRescueSection() {
    return Column(
      children: [
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "救援治療 (Rescue)",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "• Catheter-directed (EKOS): 溶栓失敗或禁忌症時。",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "• VA-ECMO: 頑固性休克/IHCA，作為橋接。",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "• IVC Filter: 僅用於絕對禁忌抗凝血或反覆栓塞者。",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildExpTile(
          "臨床珍珠 (Pearls)",
          [
            "液體管理: 小心輸液！右心衰竭時給太多水會壓扁左心 (Interdependence) 導致 CO 下降。建議 < 500ml。",
            "升壓劑: 首選 Norepinephrine (不增加肺阻力)。",
            "血壓陷阱: 年輕人代償好，大面積 PE 血壓可能正常，需看 HR、Echo、Troponin。",
            "HIT: 用 Heparin 後血小板驟降 -> 換藥。",
          ],
          Icons.lightbulb,
          Colors.yellowAccent,
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
          color: Colors.tealAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBullet(String title, String content) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.circle, size: 6, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(content, style: const TextStyle(color: Colors.white70)),
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
