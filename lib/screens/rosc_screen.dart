// lib/screens/rosc_screen.dart
import 'package:flutter/material.dart';

class RoscScreen extends StatefulWidget {
  const RoscScreen({super.key});

  @override
  State<RoscScreen> createState() => _RoscScreenState();
}

class _RoscScreenState extends State<RoscScreen> {
  // 5H5T 勾選狀態 (幫助醫師逐一排除)
  final Map<String, bool> _hChecks = {
    'Hypothermia (低體溫)': false,
    'Hypovolemia (低血容)': false,
    'Hypoxia (低血氧)': false,
    'H+ Acidosis (酸中毒)': false,
    'Hyperkalemia (高血鉀)': false,
  };

  final Map<String, bool> _tChecks = {
    'Tension Pneumothorax (氣胸)': false,
    'Tamponade (心包膜填塞)': false,
    'Thrombosis (AMI/PE)': false,
    'Toxin (藥物中毒)': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post-ROSC Care & TTM")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 5H5T 互動檢查表
          _buildSectionHeader(
            "1. Differential Diagnosis (5H5T)",
            icon: Icons.help_outline,
          ),
          Card(
            color: Colors.grey[900],
            child: ExpansionTile(
              title: const Text(
                "5H5T 快速排除",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: const Text(
                "口訣: 三低高鉀酸中毒，兩心兩肺毒藥物",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              initiallyExpanded: true,
              children: [
                ..._hChecks.keys.map((key) => _buildCheckItem(key, _hChecks)),
                const Divider(),
                ..._tChecks.keys.map((key) => _buildCheckItem(key, _tChecks)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. 低溫療法 (TTM)
          _buildSectionHeader("2. TTM 低溫療法 (32-34°C)", icon: Icons.ac_unit),
          _buildTtmIndicationCard(),
          _buildTtmProtocolCard(),

          const SizedBox(height: 16),

          // 3. 藥物與處置
          _buildSectionHeader(
            "3. Medication & Management",
            icon: Icons.medication,
          ),
          _buildMedsCard(),
          _buildElectrolyteCard(),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(String title, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 5H5T 勾選項目
  Widget _buildCheckItem(String key, Map<String, bool> map) {
    return CheckboxListTile(
      title: Text(
        key,
        style: TextStyle(
          color: map[key]! ? Colors.grey : Colors.white,
          decoration: map[key]! ? TextDecoration.lineThrough : null,
        ),
      ),
      value: map[key],
      activeColor: Colors.grey,
      checkColor: Colors.white,
      onChanged: (val) {
        setState(() {
          map[key] = val!;
        });
      },
      dense: true,
    );
  }

  // TTM 適應症與禁忌症
  Widget _buildTtmIndicationCard() {
    return Card(
      color: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "適應症 (Indication)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            const Text("• ROSC < 24hr\n• Comatose (Cannot obey command)"),
            const SizedBox(height: 12),
            const Text(
              "絕對禁忌症 (Contraindication)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const Text(
              "• 活動性出血 (需先做 Brain CT 排除 ICH)",
              style: TextStyle(color: Colors.redAccent),
            ),
            const Text("• 無法控制的心律不整"),
            const Text("• 無法控制的休克"),
          ],
        ),
      ),
    );
  }

  // TTM 流程
  Widget _buildTtmProtocolCard() {
    return Card(
      color: Colors.black45,
      child: ExpansionTile(
        title: const Text("操作流程與注意事項"),
        children: [
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.cyanAccent),
            title: const Text("療程: 持續 24 小時"),
            subtitle: const Text("原則: 快快降溫，慢慢回溫 (0.2-0.5°C/hr)"),
          ),
          ListTile(
            leading: const Icon(Icons.monitor_heart, color: Colors.cyanAccent),
            title: const Text("重點監測 (Q6H)"),
            subtitle: const Text("凝血功能、Lactate、CO、高血糖、電解質"),
          ),
          ListTile(
            leading: const Icon(Icons.psychology, color: Colors.cyanAccent),
            title: const Text("預後評估"),
            subtitle: const Text("回溫且停藥 3 天後，若未清醒 -> EEG / S-100"),
          ),
        ],
      ),
    );
  }

  // 藥物管理
  Widget _buildMedsCard() {
    return Card(
      color: Colors.grey[900],
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "Sedation & Shivering",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "務必 Total Sedation。\n若顫抖/心律不整可用: Amiodarone, MgSO4, Nimbex",
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              "尿崩症 (Diabetes Insipidus)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "監測: 尿多 + 比重低/滲透壓低\nRx: Desmopressin 4 mcg ST",
            ),
          ),
        ],
      ),
    );
  }

  // 電解質目標
  Widget _buildElectrolyteCard() {
    return Card(
      color: Colors.cyan[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.cyanAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.cyanAccent),
                SizedBox(width: 8),
                Text(
                  "回溫期電解質目標",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.cyanAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "K (鉀) ≥ 4.0",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Mg (鎂) ≥ 2.0",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ca (鈣) ≥ 8.0",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "P (磷) ≥ 1.0",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
