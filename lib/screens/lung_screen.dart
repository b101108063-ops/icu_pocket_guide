// lib/screens/lung_screen.dart
import 'package:flutter/material.dart';

class LungScreen extends StatefulWidget {
  const LungScreen({super.key});

  @override
  State<LungScreen> createState() => _LungScreenState();
}

class _LungScreenState extends State<LungScreen> {
  // 移除 SingleTickerProviderStateMixin 和 TabController，因為不需要分頁了

  // 風險評估狀態 (用於抗生素選擇器)
  bool _isHighRisk = false; // Late-onset, Shock, MDR risk
  bool _isMrsaRisk = false; // MRSA risk factor

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      // 直接顯示肺炎內容，不再使用 TabBarView
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 定義與診斷陷阱
          _buildHeader("1. 定義與診斷 (Diagnosis)"),
          _buildDefinitionCard(),
          const SizedBox(height: 16),

          // 2. 風險評估與抗生素 (核心功能)
          _buildHeader("2. 經驗性抗生素 (Empiric Rx)"),
          _buildAntibioticSelector(),
          const SizedBox(height: 16),

          // 3. 預防與珍珠
          _buildHeader("3. VAP Bundle & Pearls"),
          _buildPearlsCard(),
          const SizedBox(height: 16),

          // 4. 肺炎旁胸水
          _buildHeader("4. 肺炎旁胸水 (Effusion)"),
          _buildEffusionTable(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 定義卡片 ---
  Widget _buildDefinitionCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "HAP vs VAP & 診斷閾值",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "CXR 特異性僅 26%，需依賴微生物",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        initiallyExpanded: false,
        children: [
          _buildRow("HAP", "住院 ≥ 48hr", Colors.white),
          _buildRow("VAP", "插管 ≥ 48hr", Colors.white),
          _buildRow("Early-onset", "< 5 天 (MDR 風險低)", Colors.greenAccent),
          _buildRow("Late-onset", "≥ 5 天 (MDR 風險高)", Colors.redAccent),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "定量培養閾值 (Quantitative Thresholds):",
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _buildRow("BAL (最佳)", "> 10,000 (10^4) CFU/ml", Colors.white),
          _buildRow("PSB (毛刷)", "> 1,000 (10^3) CFU/ml", Colors.white),
          _buildRow("Tracheal Asp.", "> 100,000 (10^5) CFU/ml", Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "⚠️ 篩檢: 若 Squamous cells > 10 /LPF，代表口腔汙染，不可信。",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. 抗生素選擇器 ---
  Widget _buildAntibioticSelector() {
    return Card(
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          // Toggles
          SwitchListTile(
            title: const Text(
              "High Risk / Late-onset?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "插管≥5天, 休克, 90天內用過抗生素, 洗腎, ARDS",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _isHighRisk,
            activeColor: Colors.redAccent,
            onChanged: (v) => setState(() => _isHighRisk = v),
          ),
          SwitchListTile(
            title: const Text(
              "MRSA Risk?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "盛行率高或有 MRSA 病史",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            value: _isMrsaRisk,
            activeColor: Colors.orangeAccent,
            onChanged: (v) => setState(() => _isMrsaRisk = v),
          ),
          const Divider(color: Colors.white24),

          // Result Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isHighRisk
                      ? "🔴 High Risk VAP (MDR Coverage)"
                      : "🟢 Low Risk VAP (Early-onset)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isHighRisk ? Colors.redAccent : Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 8),
                if (!_isHighRisk) ...[
                  const Text(
                    "策略: 單藥治療 (Monotherapy)",
                    style: TextStyle(color: Colors.white70),
                  ),
                  _buildDrugTile(
                    "涵蓋: MSSA + GNB",
                    "Cefepime, Levofloxacin, 或 Pip-Tazo",
                  ),
                ] else ...[
                  const Text(
                    "策略: 聯合治療 (Combination Therapy)",
                    style: TextStyle(color: Colors.white70),
                  ),
                  _buildDrugTile(
                    "1. Anti-Pseudomonas (β-lactam)",
                    "Pip-Tazo, Cefepime, 或 Meropenem",
                  ),
                  _buildDrugTile(
                    "2. Anti-Pseudomonas (Non-β)",
                    "Levofloxacin 或 Amikacin (若疑抗藥)",
                  ),
                ],
                if (_isMrsaRisk || _isHighRisk)
                  _buildDrugTile("3. Anti-MRSA", "Vancomycin 或 Linezolid"),

                const SizedBox(height: 8),
                const Text(
                  "療程: 7 天 (若反應良好)。儘早停藥。",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Pearls ---
  Widget _buildPearlsCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.purpleAccent),
            title: const Text(
              "Candida (念珠菌)",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "痰培養常見，但「極少」引起肺炎。通常只需觀察，不需治療。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shield, color: Colors.blueAccent),
            title: const Text(
              "VAP Prevention",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "• 床頭抬高 30-45度\n• 每日評估拔管 (SBT)\n• 避免常規灌水抽痰",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. 胸水表格 ---
  Widget _buildEffusionTable() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildRow("類別", "特徵", Colors.tealAccent, isHeader: true),
            const Divider(color: Colors.white24),
            _buildRow("單純 (Simple)", "pH > 7.20\n無菌", Colors.white),
            _buildRow(
              "複雜 (Complicated)",
              "pH < 7.20\nGram stain (+)",
              Colors.orangeAccent,
            ),
            _buildRow("膿胸 (Empyema)", "抽出膿液 (Pus)", Colors.redAccent),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "處置: 複雜性與膿胸需插胸管引流 (Chest Tube)",
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          color: Colors.blueAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRow(
    String col1,
    String col2,
    Color color, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              col1,
              style: TextStyle(
                color: color,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              col2,
              style: TextStyle(
                color: isHeader ? color : Colors.white70,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugTile(String title, String drug) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.medication, color: Colors.tealAccent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(drug, style: const TextStyle(color: Colors.tealAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
