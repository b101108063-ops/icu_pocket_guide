// lib/screens/gi_screen.dart
import 'package:flutter/material.dart';

class GiScreen extends StatelessWidget {
  const GiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 穩定生命徵象 (ABC)
          _buildHeader("1. 初始穩定 (Initial Stabilization)"),
          _buildAbcCard(),
          const SizedBox(height: 16),

          // 2. 藥物治療 (UGIB vs EV)
          _buildHeader("2. 藥物治療 (Pharmacotherapy)"),
          _buildTreatmentSection(),
          const SizedBox(height: 16),

          // 3. 輸血策略
          _buildHeader("3. 輸血與凝血 (Transfusion)"),
          _buildTransfusionCard(),
          const SizedBox(height: 16),

          // 4. 介入處置
          _buildHeader("4. 檢查與介入 (Procedures)"),
          _buildProcedureCard(),
          const SizedBox(height: 16),

          // 5. 臨床珍珠
          _buildHeader("5. 臨床珍珠 (Pearls)"),
          _buildPearlsCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. ABC Card ---
  Widget _buildAbcCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "🚨 A (Airway)",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "• 若 GCS < 8 或持續嘔血 ⮕ 預防性插管 (防吸入性肺炎)。",
              style: TextStyle(color: Colors.white70),
            ),
            Divider(color: Colors.white24),
            Text(
              "💉 C (Circulation)",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "• 管路: 兩條 18G 軟針 或 CVC / Double Lumen。",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "• 檢視: 停用 Anti-platelet / Warfarin / DOAC。",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "• 抽血: CBC, PT/aPTT, Cross-match (備血)。",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. 藥物治療 ---
  Widget _buildTreatmentSection() {
    return Column(
      children: [
        _buildExpTile(
          "A. 非靜脈曲張 (Peptic Ulcer)",
          [
            "藥物: PPI (Pantoprazole/Omeprazole)",
            "Loading: 80 mg IV bolus。",
            "Maint: 8 mg/hr run 72hr (維持胃酸 pH>6)。",
          ],
          Icons.medical_services,
          Colors.greenAccent,
        ),

        _buildExpTile(
          "B. 靜脈曲張 (EV Bleeding)",
          [
            "適用: 肝硬化、黃疸、腹水、蜘蛛斑 (勿等胃鏡)。",
            "首選: Terlipressin 1mg (1 vial) IV Q6H。",
            "替代: Somatostatin 3000mcg/12hr。",
            "替代: Octreotide 50mcg bolus -> 50mcg/hr。",
            "抗生素: Ceftriaxone 1g QD (預防 SBP，必開)。",
          ],
          Icons.health_and_safety,
          Colors.orangeAccent,
        ), // liver icon replacement

        _buildExpTile(
          "C. 止血劑 (Antifibrinolytics)",
          ["Transamin: 可考慮 250-500mg IV Q6-8H。"],
          Icons.medication_liquid,
          Colors.grey,
        ),
      ],
    );
  }

  // --- 3. 輸血策略 ---
  Widget _buildTransfusionCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "Hb 目標",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "> 7-8 g/dL 即可。過度輸血 (>10) 易增加門脈壓致再出血。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            title: const Text(
              "大量輸血協定 (MTP)",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "出血 > 2000ml 或休克。\nRBC : FFP : Platelet = 1 : 1 : 1\n⚠️ 記得補鈣 (每4-6U RBC 給1支 Ca-gluconate)。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            title: const Text(
              "尿毒症出血 (Uremia)",
              style: TextStyle(
                color: Colors.yellowAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "DDAVP 16mcg + NS 50ml run 30min。\n透析 (Dialysis)。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. 介入處置 ---
  Widget _buildProcedureCard() {
    return Column(
      children: [
        _buildProcedureRow(
          "UGIB",
          "胃鏡 (PES)",
          "12-24hr 內執行。\n若 EV 止不住 ⮕ SB Tube (救命)。",
        ),
        _buildProcedureRow(
          "LGIB",
          "CTA / TAE",
          "若大量鮮血便且不穩 ⮕ 先排除 UGIB，再做 CTA 栓塞。",
        ),
      ],
    );
  }

  Widget _buildProcedureRow(String type, String action, String desc) {
    return Card(
      color: Colors.blueGrey[900],
      child: ListTile(
        title: Row(
          children: [
            Text(
              type,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              action,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(desc, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }

  // --- 5. Pearls ---
  Widget _buildPearlsCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.yellow),
            title: const Text(
              "黑便 vs 鮮血便",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Melena: 通常 UGIB，但也可能右側大腸。\nHematochezia: 通常 LGIB，但大量 UGIB 也會！",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.medication, color: Colors.purpleAccent),
            title: const Text(
              "EV 三寶 (長期)",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "1. Somatostatin/Terlipressin (急性)\n2. Antibiotics (急性)\n3. Inderal (Propranolol) (預防, HR 55-60)",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
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
          color: Colors.orangeAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
