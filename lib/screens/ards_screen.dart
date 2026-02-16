// lib/screens/ards_screen.dart
import 'package:flutter/material.dart';

class ArdsScreen extends StatefulWidget {
  const ArdsScreen({super.key});

  @override
  State<ArdsScreen> createState() => _ArdsScreenState();
}

class _ArdsScreenState extends State<ArdsScreen> {
  // 控制計算機的變數
  final TextEditingController _heightController = TextEditingController();
  bool _isMale = true;
  double? _pbw; // Predicted Body Weight
  double? _targetVT;

  // 內建 PBW 計算邏輯 (取代外部引用，避免找不到檔案)
  void _calculate() {
    if (_heightController.text.isNotEmpty) {
      double height = double.parse(_heightController.text);
      setState(() {
        // 男性 PBW: 50 + 0.91 * (身高 cm - 152.4)
        // 女性 PBW: 45.5 + 0.91 * (身高 cm - 152.4)
        _pbw = (_isMale ? 50.0 : 45.5) + 0.91 * (height - 152.4);
        _targetVT = _pbw! * 6.0; // 目標 6 mL/kg
      });
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. PBW 與 VT 計算機 (置頂最常用)
          _buildCalculatorCard(),
          const SizedBox(height: 16),

          // 2. 柏林定義 (Berlin Definition)
          _buildHeader("1. 快速診斷標準 (Berlin Definition)"),
          _buildBerlinCard(),
          const SizedBox(height: 16),

          // 3. 核心治療：肺保護通氣策略
          _buildHeader("2. 核心治療：肺保護通氣 (LPV)"),
          _buildLpvCard(),
          const SizedBox(height: 16),

          // 4. 救援治療：俯臥通氣
          _buildHeader("3. 救援治療：俯臥通氣 (Prone)"),
          _buildProneCard(),
          const SizedBox(height: 16),

          // 5. 藥物與液體管理
          _buildHeader("4. 藥物治療與液體管理"),
          _buildMedsCard(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 計算機 ---
  Widget _buildCalculatorCard() {
    return Card(
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.calculate, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  "PBW & 潮氣容積計算機",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "身高 (cm)",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixText: "cm",
                    ),
                    onChanged: (val) => _calculate(),
                  ),
                ),
                const SizedBox(width: 16),
                ToggleButtons(
                  isSelected: [_isMale, !_isMale],
                  selectedColor: Colors.white,
                  fillColor: Colors.blueAccent.withOpacity(0.5),
                  color: Colors.grey,
                  borderColor: Colors.grey,
                  selectedBorderColor: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                  onPressed: (index) {
                    setState(() {
                      _isMale = index == 0;
                      _calculate();
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("男"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("女"),
                    ),
                  ],
                ),
              ],
            ),
            if (_pbw != null) ...[
              const Divider(height: 24, color: Colors.white24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResultItem(
                    "預測體重 (PBW)",
                    "${_pbw!.toStringAsFixed(1)} kg",
                    Colors.white,
                  ),
                  _buildResultItem(
                    "目標 VT (6ml/kg)",
                    "${_targetVT!.toStringAsFixed(0)} ml",
                    Colors.greenAccent,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "⚠️ 絕不能用實際體重計算，肥胖患者會被打爆肺！",
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // --- 2. Berlin Definition ---
  Widget _buildBerlinCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "Berlin Definition (符合以下所有)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: false,
        children: [
          //
          _buildListTile("時效 (Timing)", "發生於已知臨床傷害或新症狀 7 天內。"),
          _buildListTile(
            "影像 (Imaging)",
            "CXR/CT 顯示雙側浸潤 (Bilateral infiltrates)，排除積水/塌陷。",
          ),
          _buildListTile("水腫原因 (Origin)", "需排除心衰竭或體液過負荷 (必要時掃 Echo)。"),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              "氧合狀態 (Oxygenation) @ PEEP ≥ 5:",
              style: TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildListTile("Mild (輕度)", "200 < P/F ratio ≤ 300"),
          _buildListTile("Moderate (中度)", "100 < P/F ratio ≤ 200"),
          _buildListTile(
            "Severe (重度)",
            "P/F ratio ≤ 100",
            textColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  // --- 3. 肺保護通氣 (LPV) ---
  Widget _buildLpvCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "Lung Protective Ventilation (LPV)",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: true,
        children: [
          //
          _buildExpSection("A. 低潮氣容積 (Low Tidal Volume)", [
            "目標: 6 mL/kg PBW (預測體重)。",
            "流程: 初始設 8 mL/kg，每 2hr 降 1 mL/kg 直到達標。",
            "若發生嚴重不同步 (Dyssynchrony) 可暫時調高，但應盡快降回。",
          ]),
          _buildExpSection("B. 限制高原壓 (Plateau Pressure)", [
            "安全上限: Pplat ≤ 30 cmH2O (End-inspiratory hold測量)。",
            "Troubleshooting: 若 >30，繼續調降 VT (最低可至 4 mL/kg)，即便造成高碳酸血症。",
          ]),
          _buildExpSection("C. 容許性高碳酸血症 (Permissive Hypercapnia)", [
            "pH 目標: 7.30 - 7.45。",
            "pH 7.15-7.30: 增加 RR 直到 35 bpm。",
            "pH < 7.15: RR=35，若仍酸則不得不增加 VT。",
          ]),
          _buildExpSection("D. High PEEP 策略", [
            "Best PEEP: 尋找能達到「最佳肺順應性」或「最低驅動壓 (Driving Pressure)」的值。",
            "公式: Driving Pressure = Pplat - PEEP。",
            "⚠️ 警告: 過高 PEEP 會導致死腔增加、CO 下降 (右心後負荷增加)。若 P/F 升但 BP 垮掉，氧氣輸送 (DO2) 其實是下降的！",
          ]),
        ],
      ),
    );
  }

  // --- 4. 俯臥通氣 (Prone) ---
  Widget _buildProneCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "Prone Positioning (俯臥通氣)",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          //
          _buildExpSection("適應症與操作 (Indications)", [
            "時機: P/F ratio < 150 (Mod-Severe)。",
            "條件: 已使用 FiO2 ≥ 60%, PEEP ≥ 5, 且已設定 Low VT。",
            "時間: 每天至少需維持 16 小時於俯臥姿勢。",
            "機轉: 改善 V/Q mismatch、均勻化跨肺壓、減少 VILI。",
          ]),
          _buildExpSection("⚠️ 絕對禁忌症 (Contraindications)", [
            "• 活動性出血 (Active hemorrhage)。",
            "• 脊椎不穩定 (Spinal instability)。",
            "• 顱內壓升高 (Increased ICP)。",
            "• 近期開胸或氣切手術 (< 2週)。",
          ], isWarning: true),
        ],
      ),
    );
  }

  // --- 5. 藥物與液體 (Meds & Fluids) ---
  Widget _buildMedsCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text(
          "Medications & Fluids",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          _buildExpSection("A. 類固醇 (Corticosteroids)", [
            "COVID-19: Dexamethasone 6mg IV/PO QD x 10天。",
            "Non-COVID (早期 <72hr): Methylprednisolone 1 mg/kg/day。",
            "Non-COVID (晚期 7-14天): Methylprednisolone 2 mg/kg/day。",
            "建議持續 14 天並逐漸減量 (Taper)。",
          ]),
          _buildExpSection("B. 神經肌肉阻斷劑 (NMB - Cisatracurium)", [
            "角色: 非常規使用。",
            "時機: 嚴重 ARDS (P/F < 150) 早期 <48hr，嚴重人機對抗或執行 Prone 時使用。",
            "注意: 長期使用會導致重症肌無力 (CIP/CIM)。",
          ]),
          _buildExpSection("C. 液體管理 (Fluid) & 鎮靜 (Sedation)", [
            "Fluid: 保守/乾 (Conservative/Dry)。脫離休克後積極維持體液「負平衡」。",
            "Sedation: 急性期為配合 Low VT (避免吸氣太強造成 P-SILI)，可能需較深鎮靜。",
          ]),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle, {
    Color textColor = Colors.white70,
  }) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: textColor)),
    );
  }

  Widget _buildExpSection(
    String title,
    List<String> items, {
    bool isWarning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isWarning ? Colors.redAccent : Colors.tealAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                      color: isWarning ? Colors.redAccent : Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      i,
                      style: TextStyle(
                        color: isWarning ? Colors.red[100] : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
