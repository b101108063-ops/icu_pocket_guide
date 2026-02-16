// lib/screens/copd_asthma_screen.dart
import 'package:flutter/material.dart';

class CopdAsthmaScreen extends StatelessWidget {
  const CopdAsthmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 快速評估與危險徵兆
          _buildHeader("1. 快速評估與危險徵兆 (Assessment)"),
          _buildDangerSignsCard(),
          const SizedBox(height: 16),

          // 2. 藥物治療 (核心)
          _buildHeader("2. 藥物治療策略 (Pharmacotherapy)"),
          _buildMedsSection(),
          const SizedBox(height: 16),

          // 3. 救援治療
          _buildHeader("3. 救援治療 (Rescue Therapies)"),
          _buildRescueCard(),
          const SizedBox(height: 16),

          // 4. 呼吸照護與 Vent 設定
          _buildHeader("4. 呼吸器設定 (Ventilator Strategy)"),
          _buildVentCard(),
          const SizedBox(height: 16),

          // 5. Troubleshooting (Auto-PEEP)
          _buildHeader("5. 異常排除 (Troubleshooting)"),
          _buildTroubleCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 危險徵兆卡片 ---
  Widget _buildDangerSignsCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orangeAccent),
                SizedBox(width: 8),
                Text(
                  "危險徵兆 (Red Flags)",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "• 寂靜胸 (Silent Chest): 聽不到喘鳴聲。",
              style: TextStyle(color: Colors.white),
            ),
            Divider(color: Colors.white24),
            Text(
              "⚠️ ABG 陷阱 (Asthma):",
              style: TextStyle(
                color: Colors.yellowAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("急性發作時 PaCO2 應偏低。", style: TextStyle(color: Colors.white70)),
            Text(
              "若呼吸費力但 PaCO2 正常 (40-42) ➡ 提示即將呼吸衰竭 (Impending Failure)，準備插管！",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. 藥物治療 ---
  Widget _buildMedsSection() {
    return Column(
      children: [
        _buildStepTile(
          "A. 支氣管擴張劑 (Bronchodilators)",
          "SABA (Albuterol) + SAMA (Atrovent)",
          [
            "SABA: Nebulizer 2.5-5mg Q20min x 3次。",
            "若無效: 改 Continuous Neb 5-15 mg/hr。",
            "SAMA: 0.5mg Q20min x 3次 (僅急性期有效)。",
            "副作用: 震顫、低血鉀、乳酸升高 (Type B)。",
          ],
          Icons.air,
          Colors.blueAccent,
        ),
        _buildStepTile(
          "B. 類固醇 (Corticosteroids)",
          "盡早給予 (起效需 6-12hr)",
          [
            "Asthma: Solu-Medrol 40-80 mg/day IV。療程 7-10 天 (免 Taper)。",
            "COPD: Prednisolone 40 mg/day。療程 5 天。",
            "口服 (PO) 與靜脈 (IV) 效果相當。",
          ],
          Icons.medication,
          Colors.orangeAccent,
        ),
        _buildStepTile(
          "C. 抗生素 (Antibiotics)",
          "COPD 強烈建議；Asthma 通常不用",
          [
            "COPD 適應症: 痰量增、變濃/黃、需插管。",
            "經驗性: 覆蓋 H.flu, Pneumococcus。",
            "ICU/插管: 需覆蓋 Pseudomonas (如 Cefepime)。",
          ],
          Icons.bug_report,
          Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _buildStepTile(
    String title,
    String subtitle,
    List<String> details,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        children: details
            .map(
              (d) => ListTile(
                dense: true,
                leading: const Icon(Icons.circle, size: 6, color: Colors.grey),
                title: Text(d, style: const TextStyle(color: Colors.white70)),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- 3. 救援治療 ---
  Widget _buildRescueCard() {
    return Card(
      color: Colors.purple.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildRow(
              "Magnesium",
              "2g IV run 15-30min",
              "鈣離子阻斷，舒張支氣管",
              Colors.purpleAccent,
            ),
            const Divider(color: Colors.white24),
            _buildRow(
              "Ketamine",
              "Load 0.1-0.2 mg/kg",
              "鎮靜 + 支氣管擴張",
              Colors.purpleAccent,
            ),
            const Divider(color: Colors.white24),
            _buildRow("Heliox", "氦氧混合氣", "降低氣流阻力 (非常規)", Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String drug, String dose, String note, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              drug,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(dose, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 4,
            child: Text(
              note,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. 呼吸器設定 (Ventilator) ---
  Widget _buildVentCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "設定策略: 延長吐氣時間 (TE)",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: true,
        children: [
          _buildVentRow("Mode", "AC / Volume Control"),
          _buildVentRow("Tidal Volume", "6-8 ml/kg PBW (避免過度充氣)"),
          _buildVentRow("RR (關鍵)", "10-14 bpm (設慢，讓氣吐乾淨)"),
          _buildVentRow("Flow Rate", "60-80 L/min (設快，縮短 TI)"),
          _buildVentRow("I:E Ratio", "1:3 或 1:4"),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "允許性高碳酸血症 (Permissive Hypercapnia): pH ≥ 7.15 即可接受。",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVentRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            val,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. Auto-PEEP Troubleshooting ---
  Widget _buildTroubleCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "低血壓 (Hypotension) 處置",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "• 原因: Auto-PEEP 過高導致靜脈回流受阻 (類 Tamponade)。",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 4),
            Text(
              "• 動作: 斷開管路 (Disconnect) 幾秒鐘。",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "   (讓氣體排出，若血壓回升即確診)",
              style: TextStyle(color: Colors.white70),
            ),
            Divider(color: Colors.white24),
            Text(
              "• 調整: 降 RR、降 Vt、增 Flow。",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
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
          color: Colors.tealAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
