// lib/screens/sepsis_screen.dart
import 'package:flutter/material.dart';

class SepsisScreen extends StatefulWidget {
  const SepsisScreen({super.key});

  @override
  State<SepsisScreen> createState() => _SepsisScreenState();
}

class _SepsisScreenState extends State<SepsisScreen> {
  // 輸液計算狀態
  final TextEditingController _weightController = TextEditingController();
  double _weight = 60.0;
  double _fluidVolume = 1800.0; // 預設 60 * 30

  // 抗生素決策狀態
  bool _hasShock = true; // 是否有休克
  String _sepsisProb = 'Definite'; // 敗血症可能性: Definite, Possible

  @override
  void initState() {
    super.initState();
    _weightController.text = "60";
    _weightController.addListener(_updateFluid);
  }

  void _updateFluid() {
    setState(() {
      _weight = double.tryParse(_weightController.text) ?? 0;
      _fluidVolume = _weight * 30; // 核心公式: 30ml/kg
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sepsis & Shock Management")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 輸液復甦計算機
          _buildSectionHeader("1. Fluid Resuscitation (前3小時)"),
          _buildFluidResuscitationCard(),
          const SizedBox(height: 16),

          // 2. 抗生素時機
          _buildSectionHeader("2. Antibiotic Timing (2021 Guidelines)"),
          _buildAntibioticDecisionCard(),
          const SizedBox(height: 16),

          // 3. 升壓劑與目標
          _buildSectionHeader("3. Vasoactive & Early Goals"),
          _buildVasopressorCard(),
          _buildGoalsCard(),

          const SizedBox(height: 16),

          // 4. 2021 更新重點
          _buildUpdateInfoCard(),
        ],
      ),
    );
  }

  // --- UI 元件區 ---

  Widget _buildSectionHeader(String title) {
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

  // 1. 輸液計算機
  Widget _buildFluidResuscitationCard() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "建議劑量: 30 mL/kg (Balanced Crystalloids)",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "病人體重 (kg)",
                      border: OutlineInputBorder(),
                      suffixText: "kg",
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("需給予輸液量:", style: TextStyle(fontSize: 12)),
                      Text(
                        "${_fluidVolume.toStringAsFixed(0)} mL",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.redAccent, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "注意: 避免使用 N/S (高氯酸血症) 或 Gelatin",
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. 抗生素決策樹
  Widget _buildAntibioticDecisionCard() {
    // 判斷邏輯
    String actionText = "";
    Color actionColor = Colors.green;

    if (_hasShock) {
      actionText = "立即給予 (1小時內)";
      actionColor = Colors.redAccent;
    } else {
      if (_sepsisProb == 'Definite') {
        actionText = "立即給予 (1小時內)";
        actionColor = Colors.orangeAccent;
      } else {
        actionText = "快速評估 (若仍懷疑 -> 3小時內給)";
        actionColor = Colors.yellowAccent;
      }
    }

    return Card(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 問答開關
            SwitchListTile(
              title: const Text(
                "是否休克 (Shock Present)?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: _hasShock,
              activeColor: Colors.redAccent,
              onChanged: (val) => setState(() => _hasShock = val),
            ),
            if (!_hasShock) ...[
              const Divider(),
              const Text("敗血症可能性 (Sepsis Probability):"),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("明確/極可能"),
                      value: 'Definite',
                      groupValue: _sepsisProb,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _sepsisProb = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("可能/不明"),
                      value: 'Possible',
                      groupValue: _sepsisProb,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _sepsisProb = val!),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            // 結果顯示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: actionColor.withOpacity(0.2),
                border: Border.all(color: actionColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text("建議處置", style: TextStyle(color: Colors.grey)),
                  Text(
                    actionText,
                    style: TextStyle(
                      color: actionColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 升壓劑與目標
  Widget _buildVasopressorCard() {
    return ExpansionTile(
      title: const Text("升壓劑階梯 (Vasopressors)"),
      subtitle: const Text("Fluid Challenge 後 MAP < 65"),
      initiallyExpanded: true,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red[900],
            child: const Text("1"),
          ),
          title: const Text("Norepinephrine (Levophed)"),
          subtitle: const Text("首選藥物。可暫由周邊大靜脈給予。"),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange[900],
            child: const Text("2"),
          ),
          title: const Text("Vasopressin"),
          subtitle: const Text("若 MAP 仍不足時加上 (通常 0.03 U/min)"),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.yellow[900],
            child: const Text("3"),
          ),
          title: const Text("Epinephrine / Dobutamine"),
          subtitle: const Text("若心功能差 (低灌流) 或難治性休克"),
        ),
      ],
    );
  }

  Widget _buildGoalsCard() {
    return const Card(
      color: Colors.black45,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Early Goals (6hr 內)",
              style: TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _GoalRow("MAP", "≥ 65 mmHg"),
            _GoalRow("Urine Output", "> 0.5 mL/kg/hr"),
            _GoalRow("Lactate", "Clearance > 10-20% (每2hr追蹤)"),
            _GoalRow("Hb", "> 10 g/dL (MICU 特別建議)"),
            _GoalRow("CVP (插管)", "12 - 15 mmHg"),
          ],
        ),
      ),
    );
  }

  // 4. 2021 Updates 資訊卡
  Widget _buildUpdateInfoCard() {
    return ExpansionTile(
      title: const Text("2021 SSC Guideline 更新重點"),
      collapsedIconColor: Colors.grey,
      children: const [
        ListTile(
          leading: Icon(Icons.close, color: Colors.red),
          title: Text("不建議單用 qSOFA 篩檢"),
        ),
        ListTile(
          leading: Icon(Icons.check, color: Colors.green),
          title: Text("微循環評估: Capillary Refill Time (CRT)"),
        ),
        ListTile(
          leading: Icon(Icons.masks, color: Colors.blue),
          title: Text("呼吸衰竭: HFNC 優於 NIV"),
        ),
        ListTile(
          leading: Icon(Icons.medication, color: Colors.purple),
          title: Text("難治性休克: 加 IV Steroid"),
        ),
      ],
    );
  }
}

class _GoalRow extends StatelessWidget {
  final String label;
  final String target;
  const _GoalRow(this.label, this.target);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            target,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
