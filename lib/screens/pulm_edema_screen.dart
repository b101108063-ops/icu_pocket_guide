// lib/screens/pulm_edema_screen.dart
import 'package:flutter/material.dart';

class PulmEdemaScreen extends StatefulWidget {
  const PulmEdemaScreen({super.key});

  @override
  State<PulmEdemaScreen> createState() => _PulmEdemaScreenState();
}

class _PulmEdemaScreenState extends State<PulmEdemaScreen> {
  // Lasix Calculator
  final TextEditingController _crController = TextEditingController();
  double? _lasixDose;

  void _calculateLasix() {
    double cr = double.tryParse(_crController.text) ?? 0;
    if (cr > 0) {
      setState(() {
        _lasixDose = cr * 30; // 生存指引速算法
      });
    }
  }

  @override
  void dispose() {
    _crController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. LMNOP 口訣 (核心)
          _buildHeader("1. 緊急處置口訣 (LMNOP)"),
          _buildLmnopCard(),
          const SizedBox(height: 16),

          // 2. 快速識別
          _buildHeader("2. 快速識別 (Recognition)"),
          _buildDiagnosisCard(),
          const SizedBox(height: 16),

          // 3. 藥物治療 (含計算機)
          _buildHeader("3. 藥物治療 (Meds)"),
          _buildMedsSection(),
          const SizedBox(height: 16),

          // 4. 特殊情境
          _buildHeader("4. 特殊情境 (Special Cases)"),
          _buildSpecialCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. LMNOP Card ---
  Widget _buildLmnopCard() {
    return Card(
      color: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildMnemonicRow(
              "L",
              "Lasix (利尿)",
              "移除體液。注意: 血管擴張效果比排尿快。",
              Colors.yellowAccent,
            ),
            _buildMnemonicRow(
              "M",
              "Morphine",
              "降低焦慮、擴張靜脈。(COPD 慎用)",
              Colors.grey,
            ),
            _buildMnemonicRow(
              "N",
              "Nitroglycerin",
              "首選! 降血壓/擴張血管 (降 Preload)。",
              Colors.redAccent,
            ),
            _buildMnemonicRow(
              "O",
              "Oxygen",
              "目標 SpO2 > 90%。",
              Colors.blueAccent,
            ),
            _buildMnemonicRow(
              "P",
              "Position / PPV",
              "坐起垂足 (High Fowler)。\nNIV (CPAP/BiPAP) 強烈建議早期使用!",
              Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMnemonicRow(
    String letter,
    String title,
    String desc,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. 診斷卡片 ---
  Widget _buildDiagnosisCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "心因性 vs 非心因性 (ARDS)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "粉紅色泡沫痰 (Pink Frothy Sputum)",
          style: TextStyle(color: Colors.pinkAccent),
        ),
        children: [
          _buildRow("特徵", "Cardiogenic", "Non-Cardiogenic", isHeader: true),
          const Divider(color: Colors.white24),
          _buildRow("病史", "心衰竭, AMI, HTN", "敗血症, 創傷, 吸入"),
          _buildRow("理學", "S3, JVE, 濕囉音", "無 S3/JVE"),
          _buildRow("CXR", "肺門蝴蝶斑, Kerley B", "瀰漫性斑塊 (Patchy)"),
          _buildRow("四肢", "水腫 (Edema)", "通常無水腫"),
        ],
      ),
    );
  }

  Widget _buildRow(String c1, String c2, String c3, {bool isHeader = false}) {
    final style = TextStyle(
      color: isHeader ? Colors.tealAccent : Colors.white,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(c1, style: style)),
          Expanded(flex: 3, child: Text(c2, style: style)),
          Expanded(flex: 3, child: Text(c3, style: style)),
        ],
      ),
    );
  }

  // --- 3. 藥物與計算機 ---
  Widget _buildMedsSection() {
    return Column(
      children: [
        // Lasix Calculator
        Card(
          color: Colors.yellow[900]!.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.yellowAccent.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🚑 Lasix (Furosemide) 劑量速算",
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Creatinine: ",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _crController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _calculateLasix,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[800],
                      ),
                      child: const Text("計算"),
                    ),
                  ],
                ),
                if (_lasixDose != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "建議劑量: ${_lasixDose!.toStringAsFixed(0)} mg IV",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  "原則:\n1. 未用過: 40mg (腎差 60-80mg)\n2. 長期用: IV劑量 = 每日口服總量\n3. 若2hr尿少: Double Dose",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
        _buildExpTile(
          "A. 血管擴張劑 (Vasodilators)",
          [
            "NTG (首選): 5-10 mcg/min 開始滴定。\n   注意: 禁用于 RV Infarct, 威而鋼使用者。",
            "Nipride: 高血壓危象用 (0.2-0.5 mcg/kg/min)。",
            "角色: 降 Afterload 效果優於利尿劑。",
          ],
          Icons.bloodtype,
          Colors.redAccent,
        ),

        _buildExpTile(
          "B. 強心劑 (Inotropes)",
          ["Dobutamine: 心因性休克首選。", "Milrinone: 適用長期 Beta-blocker 使用者。"],
          Icons.monitor_heart,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  // --- 4. 特殊情境 ---
  Widget _buildSpecialCard() {
    return Column(
      children: [
        _buildExpTile(
          "Flash Pulmonary Edema",
          [
            "特徵: 突發性高血壓 + 肺水腫。",
            "原因: 雙側腎動脈狹窄 / 心肌缺血。",
            "關鍵: 積極降壓 (Afterload reduction)。NTG 效果佳。",
          ],
          Icons.flash_on,
          Colors.purpleAccent,
        ),

        _buildExpTile(
          "洗腎病人 (ESRD)",
          ["困境: 利尿劑通常無效。", "處置: 靠 NTG 擴張血管 + 緊急洗腎 (Dialysis) 脫水。"],
          Icons.water,
          Colors.blueGrey,
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
          color: Colors.cyanAccent,
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
