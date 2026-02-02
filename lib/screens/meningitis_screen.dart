// lib/screens/meningitis_screen.dart
import 'package:flutter/material.dart';

class MeningitisScreen extends StatefulWidget {
  const MeningitisScreen({super.key});

  @override
  State<MeningitisScreen> createState() => _MeningitisScreenState();
}

class _MeningitisScreenState extends State<MeningitisScreen> {
  // LP 檢查清單狀態
  bool _consentSigned = false;
  bool _orderSetSent = false;

  // 壓力紀錄 (暫存用，提醒醫師要測)
  final TextEditingController _openPressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meningitis & LP"),
        backgroundColor: Colors.deepPurple, // 神經感染，用深紫色
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 臨床警示
          _buildAlertCard(),

          const SizedBox(height: 16),

          // 2. LP 操作指引
          _buildSectionHeader("2. Lumbar Puncture (LP) Protocol"),
          _buildLpGuideCard(),

          const SizedBox(height: 16),

          // 3. 經驗性抗生素
          _buildSectionHeader("3. Empirical Antibiotics"),
          _buildAntibioticCard(),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.deepPurpleAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 1. 臨床警示卡
  Widget _buildAlertCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.add_alert, color: Colors.redAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "高度懷疑徵象 (Red Flags)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.redAccent),
            _buildSymptomRow("Fever (發燒)"),
            _buildSymptomRow("Headache (頭痛)"),
            _buildSymptomRow("Neck Stiffness (頸部僵硬)"),
            _buildSymptomRow("Confusion (意識混亂)"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.redAccent,
              child: const Text(
                "Action: 儘速執行 LP！",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.white70,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // 2. LP 操作卡片
  Widget _buildLpGuideCard() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text("Consent Form (同意書)"),
              subtitle: const Text("需家屬簽署"),
              value: _consentSigned,
              activeColor: Colors.deepPurpleAccent,
              onChanged: (v) => setState(() => _consentSigned = v!),
            ),
            CheckboxListTile(
              title: const Text("Order Set (組套)"),
              subtitle: const Text("使用系統 LP Protocol 開立檢驗"),
              value: _orderSetSent,
              activeColor: Colors.deepPurpleAccent,
              onChanged: (v) => setState(() => _orderSetSent = v!),
            ),
            const Divider(),
            const Text(
              "關鍵紀錄 (Critical Record):",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _openPressController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Open Pressure",
                      suffixText: "cmH2O",
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Close Pressure",
                      suffixText: "cmH2O",
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "註: 若 LP 困難，考慮 Contrast MRI (但病人常無法配合)",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 抗生素卡片
  Widget _buildAntibioticCard() {
    return Card(
      color: Colors.deepPurple[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.deepPurpleAccent.withOpacity(0.2),
            child: const Row(
              children: [
                Icon(Icons.warning, color: Colors.yellowAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "High Dose Required for BBB Penetration!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildDrugTile(
            "Ceftriaxone",
            "High Dose",
            "需穿透血腦障壁\n(勿用一般肺炎劑量，請確認 Dose)",
          ),
          _buildDrugTile("Ampicillin", "Listeria Coverage", "年長/免疫不全者必加"),
          _buildDrugTile("Vancomycin", "Resistant Strains", "針對抗藥性菌株"),
          const Divider(color: Colors.deepPurpleAccent),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "⚠️ 住院醫師請務必與藥師確認最終劑量",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugTile(String name, String role, String note) {
    return ListTile(
      leading: const Icon(Icons.medication, color: Colors.white),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.lightBlueAccent,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          Text(note, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
