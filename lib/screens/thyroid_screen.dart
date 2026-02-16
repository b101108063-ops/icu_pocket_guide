// lib/screens/thyroid_screen.dart
import 'package:flutter/material.dart';

class ThyroidScreen extends StatelessWidget {
  const ThyroidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              color: Colors.grey[850],
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: "Thyroid Storm (風暴)"),
                  Tab(text: "Myxedema Coma (昏迷)"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [_buildStormTab(), _buildComaTab()]),
            ),
          ],
        ),
      ),
    );
  }

  // --- Tab 1: Thyroid Storm (Hot / Orange Theme) ---
  Widget _buildStormTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 識別與診斷 (Diagnosis)", Colors.orangeAccent),
        Card(
          color: Colors.orange.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.orangeAccent.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Burch-Wartofsky 重點:",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text("• CNS: 躁動、譫妄、昏迷", style: TextStyle(color: Colors.white)),
                Text(
                  "• 體溫: 高燒 > 38°C (甚至 > 40°C)",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "• CV: HR > 130, AF, Shock",
                  style: TextStyle(color: Colors.white),
                ),
                Text("• GI: 嘔吐、腹瀉、黃疸", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. 治療順序 (Order is Vital!)", Colors.orangeAccent),

        _buildStepCard("Step 1: 阻斷合成 (Synthesis)", Colors.orangeAccent, [
          "PTU (首選): Loading 500-1000mg PO -> 250mg Q4H。\n   (優點: 抑制 T4轉T3)",
          "Methimazole: 60-80mg PO QD。\n   (優點: 肝毒性低)",
        ]),

        // 關鍵警示
        Card(
          color: Colors.red[900],
          child: const ListTile(
            leading: Icon(Icons.warning, color: Colors.white),
            title: Text(
              "WAIT 1-2 HOURS!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "碘劑必須在 Step 1 之後給，否則會變成合成原料！",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),

        _buildStepCard("Step 2: 阻斷釋放 (Release)", Colors.deepOrangeAccent, [
          "Lugol's Solution: 5-10 drops PO Q6-8H。",
          "若碘過敏: Lithium 300mg PO Q8H。",
        ]),

        _buildStepCard("Step 3: 控制症狀 (Beta-Blocker)", Colors.amber, [
          "Propranolol: 60-80mg PO Q4H (可抑制 T4轉T3)。",
          "Esmolol: 若有心衰竭/氣喘，用IV drip滴定 (50-100 mcg/kg/min)。",
        ]),

        _buildStepCard("Step 4: 類固醇 (Steroids)", Colors.brown, [
          "Hydrocortisone: 300mg IV Load -> 100mg Q8H。",
          "目的: 預防腎上腺不全 + 抑制 T4轉T3。",
        ]),

        _buildStepCard("Step 5: 清除 (Cholestyramine)", Colors.grey, [
          "劑量: 4g PO QID。",
          "機轉: 阻斷腸肝循環。",
        ]),
      ],
    );
  }

  // --- Tab 2: Myxedema Coma (Cold / Cyan Theme) ---
  Widget _buildComaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 識別與診斷 (Diagnosis)", Colors.cyanAccent),
        Card(
          color: Colors.cyan.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "臨床三特徵 (Triad):",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text("1. 意識改變 (Coma)", style: TextStyle(color: Colors.white)),
                Text(
                  "2. 低體溫 (Hypothermia)",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "3. 低代謝 (Bradycardia, Hypotension)",
                  style: TextStyle(color: Colors.white),
                ),
                Divider(color: Colors.white24),
                Text(
                  "Lab: TSH通常高 (由於腦下垂體問題可正常)，Free T4 絕對低。",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. 治療順序 (Protocol)", Colors.cyanAccent),

        // 關鍵警示
        Card(
          color: Colors.red[900],
          child: const ListTile(
            leading: Icon(Icons.priority_high, color: Colors.white),
            title: Text(
              "Steroids FIRST!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "必須先給(或同時給)類固醇，再給甲狀腺素，以免誘發 Adrenal Crisis。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),

        _buildStepCard("Step 1: 類固醇 (Steroids)", Colors.purpleAccent, [
          "Hydrocortisone: 100mg IV Q8H。",
          "理由: 排除共存的腎上腺功能不全。",
        ]),

        _buildStepCard("Step 2: 甲狀腺素 (T4)", Colors.blueAccent, [
          "Levothyroxine (IV): Load 200-400 mcg -> 50-100 mcg QD。",
          "口服替代 (若無IV): Eltroxin 300mcg (3#) PO/NG stat -> 100mcg Q8H。",
          "注意: IV 劑量約為 PO 的 75%。",
        ]),

        _buildStepCard("Step 3: 支持療法 (Supportive)", Colors.tealAccent, [
          "保暖: 被動回溫 (避免過快致休克)。",
          "呼吸: 易高碳酸血症，可能需插管。",
          "水分: 雖水腫但血管內脫水，謹慎輸液。",
        ]),
      ],
    );
  }

  // --- Helpers ---
  Widget _buildHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStepCard(String title, Color color, List<String> details) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: true,
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
}
