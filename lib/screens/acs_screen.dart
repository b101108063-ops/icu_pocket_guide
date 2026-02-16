// lib/screens/acs_screen.dart
import 'package:flutter/material.dart';

class AcsScreen extends StatelessWidget {
  const AcsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 快速識別與黃金時間
          _buildHeader("1. 快速識別與黃金時間 (Golden Hour)"),
          _buildGoldenHourCard(),
          const SizedBox(height: 16),

          // 2. DAPT 關鍵藥物 (最重要的部分)
          _buildHeader("2. 雙重抗血小板藥物 (DAPT)"),
          _buildDaptSection(),
          const SizedBox(height: 16),

          // 3. 抗凝血與抗缺血藥物
          _buildHeader("3. 抗凝血與抗缺血治療"),
          _buildAdjunctMedsSection(),
          const SizedBox(height: 16),

          // 4. 救援與休克處置
          _buildHeader("4. 救援治療 (Rescue & Shock)"),
          _buildRescueSection(),
          const SizedBox(height: 16),

          // 5. 臨床珍珠 (警示)
          _buildHeader("5. 臨床珍珠 & 交班重點"),
          _buildPearlsSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 黃金時間卡片 ---
  Widget _buildGoldenHourCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          _buildTimeRow(
            "10 min",
            "完成 12-Lead ECG",
            "鑑別 STEMI vs NSTEMI",
            Colors.greenAccent,
          ),
          const Divider(color: Colors.white24, height: 1),
          _buildTimeRow(
            "90 min",
            "Door-to-Balloon (D2B)",
            "STEMI 啟動導管室",
            Colors.redAccent,
          ),
          const Divider(color: Colors.white24, height: 1),
          _buildTimeRow(
            "0 & 1 hr",
            "High-sensitivity Troponin",
            "變化 > 20% 具診斷意義",
            Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String time, String action, String note, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        action,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        note,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  // --- 2. DAPT Section (重點) ---
  Widget _buildDaptSection() {
    return Column(
      children: [
        _buildDrugCard(
          "Aspirin (必備)",
          "Loading: 300 mg (嚼碎)",
          "Maintenance: 100 mg QD",
          Colors.white,
        ),
        const SizedBox(height: 8),
        const Text(
          "＋ P2Y12 Inhibitor (擇一)",
          style: TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildDrugCard(
          "Ticagrelor (Brilinta)",
          "Loading: 180 mg (2 tab)",
          "Maint: 90 mg BID\n(優先選擇，效果快)",
          Colors.cyanAccent,
        ),
        _buildDrugCard(
          "Clopidogrel (Plavix)",
          "Loading: 300-600 mg",
          "Maint: 75 mg QD",
          Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _buildDrugCard(String name, String load, String maint, Color color) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(color: Colors.white24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Loading",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      load,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Maintenance",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      maint,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. 輔助藥物 ---
  Widget _buildAdjunctMedsSection() {
    return Column(
      children: [
        _buildExpTile(
          "Heparin (抗凝血)",
          [
            "Bolus: 60 U/kg (Max 4000U)",
            "Infusion: 12 U/kg/hr (Max 1000U/hr)",
            "目標 aPTT: 1.5 - 2.0 倍 control",
          ],
          Icons.bloodtype,
          Colors.redAccent,
        ),
        _buildExpTile(
          "Nitroglycerin (NTG)",
          [
            "適應症: 胸痛、高血壓、肺水腫",
            "用法: 5-10 mcg/min 開始滴定",
            "⚠️ 禁忌: 右心室梗塞 (RV Infarct)、威而鋼",
          ],
          Icons.water_drop,
          Colors.purpleAccent,
        ),
        _buildExpTile(
          "Beta-Blockers",
          ["時機: 24hr 內給予 (Metoprolol/Bisoprolol)", "⚠️ 禁忌: 急性心衰竭、休克、HR<60、哮喘"],
          Icons.monitor_heart,
          Colors.blueAccent,
        ),
        _buildExpTile(
          "Statin",
          ["早期給予高劑量: Atorvastatin 40-80mg QD"],
          Icons.medication,
          Colors.yellowAccent,
        ),
      ],
    );
  }

  // --- 4. 救援與休克 ---
  Widget _buildRescueSection() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "心因性休克 (Cardiogenic Shock)",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "• 定義: 低血壓 + 組織灌流不足 (Lactate↑)",
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              "• 升壓劑首選: Norepinephrine (Levophed)",
              style: TextStyle(color: Colors.white),
            ),
            const Text(
              "• 強心劑: Dobutamine (若 BP 許可)",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.white24),
            const Text(
              "機械性併發症 (突發喘/Murmur/休克)",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "• 懷疑: 乳頭肌斷裂、VSD、游離壁破裂",
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              "• 動作: 緊急 Echo + 照會外科",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. 臨床珍珠 ---
  Widget _buildPearlsSection() {
    return Column(
      children: [
        Card(
          color: Colors.redAccent,
          child: ListTile(
            leading: const Icon(Icons.warning, color: Colors.white, size: 32),
            title: const Text(
              "右心室梗塞 (RV Infarction)",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "下壁 MI (II, III, aVF) + 低血壓\n❌ 絕對禁用 NTG (會休克)\n✅ 治療是給水 (Fluid challenge)",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildExpTile(
          "交班重點 (Handoff Checklist)",
          [
            "DAPT: 吃了什麼？Loading 了沒？",
            "Cath Result: 塞哪條？放幾支？還有哪裡沒通？",
            "LVEF: 左室功能？(決定 BB/ACEI 使用)",
            "Oxygen: SaO2 < 90% 才給氧，過多會收縮血管。",
          ],
          Icons.checklist,
          Colors.greenAccent,
        ),
      ],
    );
  }

  // Helpers
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
