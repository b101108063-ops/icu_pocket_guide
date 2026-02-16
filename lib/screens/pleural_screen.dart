// lib/screens/pleural_screen.dart
import 'package:flutter/material.dart';

class PleuralScreen extends StatelessWidget {
  const PleuralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Light's Criteria (Exudate vs Transudate)
          _buildHeader("1. 分類標準 (Light's Criteria)"),
          _buildLightsCriteriaCard(),
          const SizedBox(height: 16),

          // 2. 肺炎旁胸水 (Parapneumonic) - 核心決策
          _buildHeader("2. 肺炎旁胸水處置 (Parapneumonic)"),
          _buildParapneumonicSection(),
          const SizedBox(height: 16),

          // 3. 處置與操作
          _buildHeader("3. 操作與處置 (Management)"),
          _buildManagementCard(),
          const SizedBox(height: 16),

          // 4. 臨床珍珠
          _buildHeader("4. 臨床珍珠 (Clinical Pearls)"),
          _buildPearlsCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. Light's Criteria ---
  Widget _buildLightsCriteriaCard() {
    return Card(
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "符合「任一項」即為 滲出液 (Exudate)",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(color: Colors.white24),
            _buildCriteriaRow("1. Pleural / Serum Protein", "> 0.5"),
            _buildCriteriaRow("2. Pleural / Serum LDH", "> 0.6"),
            _buildCriteriaRow("3. Pleural LDH", "> 2/3 Serum ULN"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "若全不符合 ⮕ 漏出液 (Transudate)\n常見: 心衰竭, 肝硬化, 腎病症候群",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Parapneumonic Effusion (Core Decision) ---
  Widget _buildParapneumonicSection() {
    return Column(
      children: [
        // Category 1 & 2 (Safe)
        _buildCategoryTile(
          "Cat 1-2: 單純性 (Simple)",
          "pH > 7.20, Glu > 60, Gram (-)",
          "處置: 抗生素治療，通常「不需引流」。",
          Colors.greenAccent,
        ),
        // Category 3 (Danger)
        _buildCategoryTile(
          "Cat 3: 複雜性 (Complicated)",
          "pH < 7.20, Glu < 60, Gram (+)",
          "處置: ⚠️ 必須插胸管引流 (Chest Tube)。",
          Colors.orangeAccent,
        ),
        // Category 4 (Emergency)
        _buildCategoryTile(
          "Cat 4: 膿胸 (Empyema)",
          "抽出膿液 (Pus)",
          "處置: 🚨 必須引流 + 考慮外科 (VATS)。",
          Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    String title,
    String criteria,
    String action,
    Color color,
  ) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 8),
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
            const SizedBox(height: 4),
            Text(
              criteria,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(action, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // --- 3. Management ---
  Widget _buildManagementCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "處置重點 (Procedures)",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: true,
        children: [
          _buildExpRow("超音波導引", "強烈建議使用 POCUS 定位 (避開隔房/Lung)。"),
          _buildExpRow("管路選擇", "膿胸: 8-14 Fr 小管+沖洗 效果通常足夠 (傳統才用大管)。"),
          _buildExpRow("引流失敗", "若多房性包裹 (Loculated) 引流不佳 ⮕ 照會外科 VATS。"),
          _buildExpRow("抗生素", "需覆蓋 MRSA + GNB (如 Vanco + Cefepime)。"),
        ],
      ),
    );
  }

  Widget _buildExpRow(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(desc, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  // --- 4. Pearls ---
  Widget _buildPearlsCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
            title: const Text(
              "心衰竭陷阱 (CHF)",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "利尿後蛋白濃縮，Light's criteria 可能變「假性滲出液」。\n💡 解法: 測 Serum-Pleural Protein gradient (>3.1 提示漏出液)。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.science, color: Colors.yellowAccent),
            title: const Text(
              "pH < 7.20 的意義",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "代表細菌代謝強，也是發炎導致與纖維化前兆。不引流抗生素進不去！",
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
          color: Colors.blueAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
