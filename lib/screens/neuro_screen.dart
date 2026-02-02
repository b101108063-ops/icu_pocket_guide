// lib/screens/neuro_screen.dart
import 'package:flutter/material.dart';

class NeuroScreen extends StatefulWidget {
  const NeuroScreen({super.key});

  @override
  State<NeuroScreen> createState() => _NeuroScreenState();
}

class _NeuroScreenState extends State<NeuroScreen> {
  // 狀態變數：控制上方血壓儀表板的顯示邏輯
  String _diagnosis = 'Ischemic'; // 'Ischemic', 'ICH', 'SAH'
  bool _tpaGiven = false; // 是否打了 tPA (影響缺血性中風的血壓目標)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neuro: Stroke / ICH"),
        backgroundColor: Colors.indigo[900], // 神經科用深靛色
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 動態血壓目標 (核心功能)
          _buildSectionHeader("1. BP Targets (血壓控制)"),
          _buildBpTargetDashboard(),

          const SizedBox(height: 16),

          // 2. 監測與影像
          _buildSectionHeader("2. Monitoring & Imaging"),
          _buildMonitoringCard(),

          const SizedBox(height: 16),

          // 3. 腦壓與藥物
          _buildSectionHeader("3. ICP Control & Meds"),
          _buildMedsCard(),

          const SizedBox(height: 16),

          // 4. 特殊禁忌 (tPA)
          if (_tpaGiven || _diagnosis == 'Ischemic') _buildTpaWarningCard(),
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
          color: Colors.indigoAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 1. 動態血壓儀表板
  Widget _buildBpTargetDashboard() {
    // 根據選擇的診斷，計算目標血壓
    String targetBp = "";
    String note = "";
    Color displayColor = Colors.grey;

    if (_diagnosis == 'Ischemic') {
      if (_tpaGiven) {
        targetBp = "< 180 / 105";
        note = "tPA 給藥後 24hr 標準";
        displayColor = Colors.orangeAccent;
      } else {
        targetBp = "< 220 / 120";
        note = "Permissive Hypertension (容許高血壓)";
        displayColor = Colors.greenAccent;
      }
    } else if (_diagnosis == 'ICH') {
      targetBp = "< 160 / 100";
      note = "Rapid Lowering (急性期快速降壓)";
      displayColor = Colors.redAccent;
    } else if (_diagnosis == 'SAH') {
      targetBp = "< 140 / 90";
      note = "Strict Control (嚴格控制)";
      displayColor = Colors.purpleAccent;
    }

    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 診斷選擇器
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTypeButton('Ischemic', Colors.blue),
                _buildTypeButton('ICH', Colors.red),
                _buildTypeButton('SAH', Colors.purple),
              ],
            ),
            const SizedBox(height: 16),

            // 如果是缺血性，多一個 tPA 開關
            if (_diagnosis == 'Ischemic')
              SwitchListTile(
                title: const Text(
                  "Given IV t-PA?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("已接受血栓溶解劑治療"),
                value: _tpaGiven,
                activeColor: Colors.orangeAccent,
                onChanged: (v) => setState(() => _tpaGiven = v),
              ),

            const Divider(),

            // 結果顯示區
            const Text(
              "Target BP (mmHg)",
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              targetBp,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: displayColor,
              ),
            ),
            Text(
              note,
              style: TextStyle(
                color: displayColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, Color color) {
    bool isSelected = _diagnosis == type;
    return GestureDetector(
      onTap: () => setState(() => _diagnosis = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: isSelected ? color : Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 2. 監測與影像
  Widget _buildMonitoringCard() {
    return Card(
      color: Colors.black45,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.indigoAccent),
            title: const Text("Neuro Check 頻率"),
            subtitle: const Text("Q2H (GCS + Muscle Power)"),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber, color: Colors.redAccent),
            title: const Text("緊急 CT 時機"),
            subtitle: const Text("GCS 或 Power 掉 > 2 分時\n需立即通知 VS 並排 CT"),
          ),
          ListTile(
            leading: const Icon(Icons.scanner, color: Colors.indigoAccent),
            title: const Text("Routine Follow-up"),
            subtitle: const Text(
              "IA / tPA 病人：24hr 後需追蹤 CT/MRI\n(確認無出血才可給抗血小板藥)",
            ),
          ),
        ],
      ),
    );
  }

  // 3. 藥物卡片
  Widget _buildMedsCard() {
    return ExpansionTile(
      title: const Text("IICP 降腦壓藥物"),
      initiallyExpanded: true,
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      children: [
        _buildDrugTile(
          "Mannitol (滲透壓利尿劑)",
          "IICP",
          "1 vial (#1) Q6H (建議走 CVC)",
        ),
        _buildDrugTile("Dexamethasone (類固醇)", "腦水腫", "4 mg Q6H"),
        _buildDrugTile(
          "Transamin (止血)",
          "ICH",
          "500mg + 100ml NS run 8hr (視習慣)",
        ),
      ],
    );
  }

  Widget _buildDrugTile(String name, String indication, String dose) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text("$indication\n$dose"),
      isThreeLine: true,
      dense: true,
    );
  }

  // 4. tPA 禁忌卡片 (紅色警戒)
  Widget _buildTpaWarningCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.redAccent),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.block, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  "IV t-PA 24hr 禁忌 (No Touch)",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.redAccent),
            Text("• 禁止放置 NG (鼻胃管)", style: TextStyle(fontSize: 15)),
            Text("• 禁止放置 Foley (尿管)", style: TextStyle(fontSize: 15)),
            Text("• 禁止放置 CVC / A-line", style: TextStyle(fontSize: 15)),
            Text("• 禁服任何影響凝血藥物", style: TextStyle(fontSize: 15)),
            SizedBox(height: 8),
            Text(
              "理由: 極易造成黏膜出血不止",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
