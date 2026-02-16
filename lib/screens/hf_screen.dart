// lib/screens/hf_screen.dart
import 'package:flutter/material.dart';

class HfScreen extends StatelessWidget {
  const HfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 分類與定義
          _buildHeader("1. 分類 (LVEF Classification)"),
          _buildClassificationCard(),
          const SizedBox(height: 16),

          // 2. 急性去代償 (ADHF) 處置
          _buildHeader("2. 急性處置 (ADHF Management)"),
          _buildAdhfSection(),
          const SizedBox(height: 16),

          // 3. 利尿劑策略 (重點功能)
          _buildHeader("3. 利尿劑策略 (Diuretic Strategy)"),
          _buildDiureticCard(),
          const SizedBox(height: 16),

          // 4. GDMT 四根支柱
          _buildHeader("4. GDMT (HFrEF 四根支柱)"),
          _buildGdmtSection(),
          const SizedBox(height: 16),

          // 5. 右心衰竭與珍珠
          _buildHeader("5. 特殊情況 & Clinical Pearls"),
          _buildPearlsSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 分類卡片 ---
  Widget _buildClassificationCard() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildRow("HFrEF", "≤ 40%", "Reduced (收縮功能差)", Colors.redAccent),
            _buildRow(
              "HFmrEF",
              "41-49%",
              "Mildly Reduced",
              Colors.orangeAccent,
            ),
            _buildRow(
              "HFpEF",
              "≥ 50%",
              "Preserved (舒張功能差)",
              Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String val, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              val,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. ADHF 處置 ---
  Widget _buildAdhfSection() {
    return Column(
      children: [
        _buildStepTile(
          "A. 呼吸支持 (Respiratory)",
          "NIV / CPAP",
          ["機轉: 正壓可降 Afterload，增進 CO，改善肺水腫。", "適應症: 肺水腫合併呼吸窘迫/低血氧。"],
          Icons.air,
          Colors.blueAccent,
        ),
        _buildStepTile(
          "B. 血管擴張 (Vasodilators)",
          "適用: 高血壓性 ADHF (降 Afterload)",
          [
            "NTG (首選): IV 5 mcg/min 開始，每5min上調。\n   注意: 避用於 RV infarct 或 AS。需用玻璃瓶。",
            "Nitroprusside (Nipride): 0.2-0.5 mcg/kg/min。\n   注意: 避用於 CAD (Coronary steal)。",
          ],
          Icons.bloodtype,
          Colors.redAccent,
        ),
        _buildStepTile(
          "C. 強心劑 (Inotropes)",
          "適用: 低血壓/休克 (Cold & Wet)",
          [
            "Dobutamine: 2-20 mcg/kg/min (β1 agonist)。",
            "Milrinone: PDE3 inhibitor (Inodilator)。\n   優點: 適用於長期吃 Beta-blocker 者。\n   注意: 腎功能差需減量，小心低血壓。",
          ],
          Icons.monitor_heart,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  // --- 3. 利尿劑策略 (Diuretics) ---
  Widget _buildDiureticCard() {
    return Card(
      color: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Furosemide (Lasix) 劑量原則",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildBullet("Naive (未用過):", "IV 40mg (腎差者 60-80mg)"),
            _buildBullet(
              "Chronic User:",
              "IV 劑量 = 每日口服總量 (1:1換算)\nEx: 家吃 40mg BID -> IV 80mg st",
            ),
            _buildBullet("生存速算:", "Cr x 30 = 建議施打劑量"),
            const Divider(color: Colors.white24),
            const Text(
              "Diuretic Resistance (阻抗處理)",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildBullet("1. Double Dose:", "若 2hr 尿量 < 1L，劑量加倍 (Max 200mg)。"),
            _buildBullet(
              "2. Continuous Infusion:",
              "Loading 後改 Pump (5-40 mg/hr)。",
            ),
            _buildBullet(
              "3. Sequential Blockade:",
              "加 Thiazide (Metolazone) 於 Lasix 前 30min 吃。",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(content, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- 4. GDMT Section ---
  Widget _buildGdmtSection() {
    return Column(
      children: [
        _buildGdmtTile(
          "1. ARNI / ACEI / ARB",
          "Entresto 為首選",
          "目標: 97/103 mg BID。ACEI 轉 ARNI 需停藥 36hr。",
          Colors.purpleAccent,
        ),
        _buildGdmtTile(
          "2. Beta-Blockers",
          "Carvedilol, Bisoprolol, Metoprolol",
          "需等病人乾 (Euvolume) 再用。Start low, go slow。",
          Colors.blueAccent,
        ),
        _buildGdmtTile(
          "3. MRA",
          "Spironolactone / Eplerenone",
          "注意高血鉀與腎功能。",
          Colors.yellowAccent,
        ),
        _buildGdmtTile(
          "4. SGLT2 Inhibitors",
          "Dapa- / Empagliflozin",
          "不論有無糖尿病皆可用。注意 UTI。",
          Colors.tealAccent,
        ),
      ],
    );
  }

  Widget _buildGdmtTile(String title, String drug, String note, Color color) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              drug,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              note,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. Pearls Section ---
  Widget _buildPearlsSection() {
    return Column(
      children: [
        _buildExpTile("右心衰竭 (Right Heart Failure)", [
          "特徵: JVE、水腫、D-shape LV。",
          "處置: 對 Preload 敏感。CVP 正常可給水(500ml)，但太多會壓迫 LV。",
          "升壓: 低血壓建議用 Levophed (不增肺阻力)。",
        ]),
        _buildExpTile("臨床珍珠 (Clinical Pearls)", [
          "BNP: 排陰率高。若高但不像 HF，考慮腎衰竭、感染、PE。",
          "Cardiorenal Syndrome: 腎惡化常因 Venous Congestion (CVP高) 導致灌流壓降。適度利尿反而改善腎功能。",
          "IV 轉 PO: PO 生物利用率僅 50%，轉藥時劑量可能需調升。",
        ]),
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

  Widget _buildExpTile(String title, List<String> items) {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
