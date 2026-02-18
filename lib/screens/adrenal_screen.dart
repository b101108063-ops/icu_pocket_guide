// lib/screens/adrenal_screen.dart
import 'package:flutter/material.dart';

class AdrenalScreen extends StatelessWidget {
  const AdrenalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- 新增這段 AppBar ---
      appBar: AppBar(
        title: const Text('Adrenal Insufficiency'), // 標題
        backgroundColor: Colors.redAccent[700], // 背景色 (配合 CIRCI 危急的主題色)
        leading: IconButton(
          // 雖然通常會自動出現，但加上這行可以確保一定有返回鈕
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 這一行就是「回到上一頁」的指令
        ),
      ),

      // -----------------------
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 快速識別 (CIRCI)
          _buildHeader("1. 快速識別 (CIRCI)"),
          _buildCirciCard(),
          const SizedBox(height: 16),

          // 2. 診斷流程
          _buildHeader("2. 診斷流程 (Diagnosis)"),
          _buildDiagnosisCard(),
          const SizedBox(height: 16),

          // 3. 核心治療 (藥物劑量)
          _buildHeader("3. 核心治療 (Hydrocortisone)"),
          _buildTreatmentSection(),
          const SizedBox(height: 16),

          // 4. 關鍵情境 (Clinical Pearls)
          _buildHeader("4. 關鍵情境 & 順序"),
          _buildPearlsSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ... (下面的 _buildCirciCard, _buildDiagnosisCard 等等都不用動，照舊即可) ...

  // 為了完整性，我把下面沒有變動的 Helper Function 也列在這邊，您可以直接複製上面的 build 蓋過去就好

  Widget _buildHeader(String title) {
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

  Widget _buildCirciCard() {
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
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orangeAccent),
                SizedBox(width: 8),
                Text(
                  "何時懷疑 CIRCI?",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "• 難治性休克 (Refractory Shock):",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "   對輸液反應差，且需升壓劑 (NE ≥ 0.25) 仍低血壓。",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 4),
            Text("• 不明原因發燒 (排除感染後)。", style: TextStyle(color: Colors.white70)),
            Text(
              "• 風險因子: 長期用類固醇突停、DIC、Etomidate。",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "隨機血漿皮質醇 (Random Cortisol)",
              style: TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRow("< 10 µg/dL", "提示功能不全 (Insufficiency)", Colors.redAccent),
            _buildRow("≥ 35 µg/dL", "提示功能正常 (Normal)", Colors.greenAccent),
            const Divider(color: Colors.white24),
            const Text(
              "ACTH Test (Cosyntropin 250µg):",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "若 60min 後上升幅度 < 9 µg/dL ⮕ 異常。",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            const Text(
              "⚠️ 注意: 敗血性休克時，不要等報告才給藥！",
              style: TextStyle(color: Colors.yellowAccent, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String val, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            val,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(desc, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTreatmentSection() {
    return Column(
      children: [
        _buildDrugCard("Hydrocortisone (Solu-Cortef)", "首選藥物 (糖+礦物皮質素)", [
          "Septic Shock: 200 mg/day (50mg Q6H 或 100mg Q8H)。",
          "Adrenal Crisis: 100 mg IV Q8H。",
          "Thyroid Storm: 300 mg Load -> 100 mg Q8H。",
          "停藥: 休克改善後需 Taper (幾天內)，防反彈。",
        ], Colors.blueAccent),

        _buildDrugCard("Dexamethasone", "診斷用替代藥物", [
          "優點: 不干擾 Cortisol 測量 (做 ACTH test 時用)。",
          "缺點: 缺乏礦物皮質素 (無法升壓/留鈉)，休克時較不利。",
        ], Colors.grey),
      ],
    );
  }

  Widget _buildDrugCard(
    String title,
    String subtitle,
    List<String> details,
    Color color,
  ) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        initiallyExpanded: true,
        children: details
            .map(
              (d) => ListTile(
                dense: true,
                leading: const Icon(
                  Icons.medication,
                  color: Colors.grey,
                  size: 16,
                ),
                title: Text(d, style: const TextStyle(color: Colors.white70)),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPearlsSection() {
    return Column(
      children: [
        Card(
          color: Colors.purple.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.purpleAccent.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "⚠️ Myxedema Coma 救命順序",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "1. 先給 Hydrocortisone (100mg Q8H)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "2. 再給 Thyroxine (T4)",
                  style: TextStyle(color: Colors.white),
                ),
                Divider(color: Colors.white24),
                Text(
                  "原因: 甲狀腺素會加速 Cortisol 代謝。若順序錯誤，會誘發致死性 Adrenal Crisis！",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.grey[850],
          child: ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.tealAccent),
            title: const Text(
              "Etomidate 風險",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "插管單次使用即會抑制腎上腺酵素 24-48hr。雖增加不足風險，但不一定增加死亡率。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}
