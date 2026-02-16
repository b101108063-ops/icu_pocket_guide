// lib/screens/pneumo_screen.dart
import 'package:flutter/material.dart';

class PneumoScreen extends StatelessWidget {
  const PneumoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 快速識別 (Red Flags)
          _buildHeader("1. 快速識別 (Red Flags)"),
          _buildRedFlagCard(),
          const SizedBox(height: 16),

          // 2. 診斷工具 (POCUS > CXR)
          _buildHeader("2. 診斷 (Diagnosis)"),
          _buildDiagnosisCard(),
          const SizedBox(height: 16),

          // 3. 緊急處置 (Needle & Tube)
          _buildHeader("3. 緊急處置 (Decompression)"),
          _buildEmergencyCard(),
          const SizedBox(height: 16),

          // 4. 胸瓶照護 (Suction?)
          _buildHeader("4. 胸瓶照護 (Chest Tube Mgmt)"),
          _buildChestTubeCard(),
          const SizedBox(height: 16),

          // 5. 臨床珍珠
          _buildHeader("5. 臨床珍珠 (Pearls)"),
          _buildPearlsCard(),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. Red Flags Card ---
  Widget _buildRedFlagCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.5),
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.redAccent.withOpacity(0.7), width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(children: [Icon(Icons.warning, color: Colors.yellowAccent), SizedBox(width: 8), Text("張力性氣胸 (Tension Pneumo)", style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold, fontSize: 16))]),
            SizedBox(height: 8),
            Text("• 呼吸器: Peak Pressure 飆高 + Vt 打不進去。", style: TextStyle(color: Colors.white)),
            Text("• 徵象: SpO2 驟降 + 休克 (Obstructive Shock)。", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("• 理學: 頸靜脈怒張、氣管偏移、單側呼吸音消失。", style: TextStyle(color: Colors.white70)),
            Divider(color: Colors.white24),
            Text("🚨 處置: 不穩定的病人「不要等 CXR」，直接針刺減壓！", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, backgroundColor: Colors.red)),
          ],
        ),
      ),
    );
  }

  // --- 2. Diagnosis Card ---
  Widget _buildDiagnosisCard() {
    return Card(
      color: Colors.grey[850],
      child: ExpansionTile(
        title: const Text("超音波 POCUS (黃金標準)", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
        subtitle: const Text("Supine CXR 易漏診 (Deep sulcus sign)", style: TextStyle(color: Colors.white70, fontSize: 12)),
        initiallyExpanded: true,
        children: [
          
          _buildRow("Lung Sliding", "消失 (Absent) ⮕ 高度懷疑", Colors.redAccent),
          _buildRow("Lung Point", "滑動/不滑動交界 ⮕ 100% 特異性", Colors.greenAccent),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(alignment: Alignment.centerLeft, child: Text("M-mode 徵象:", style: TextStyle(color: Colors.white70))),
          ),
          _buildRow("Seashore Sign", "沙灘徵 ⮕ 正常 (Normal)", Colors.white),
          _buildRow("Barcode Sign", "條碼徵 ⮕ 氣胸 (Pneumo)", Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(desc, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- 3. Emergency Card ---
  Widget _buildEmergencyCard() {
    return Column(
      children: [
        Card(
          color: Colors.blueGrey[900],
          child: ListTile(
            leading: const Icon(Icons.architecture, color: Colors.orangeAccent),
            title: const Text("Step 1: 針刺減壓 (Needle)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text("位置: 5th ICS (腋中線前緣)。\n工具: 14G 大號長針 (8cm)。\n理由: 傳統 2nd ICS 失敗率高。", style: TextStyle(color: Colors.white70)),
          ),
        ),
        const Icon(Icons.arrow_downward, color: Colors.grey),
        Card(
          color: Colors.blueGrey[900],
          child: ListTile(
            leading: const Icon(Icons.back_hand, color: Colors.orangeAccent), // finger
            title: const Text("Step 2: 手指造口 (Finger)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text("若針刺無效，用刀片切開，手指伸入排氣。", style: TextStyle(color: Colors.white70)),
          ),
        ),
        const Icon(Icons.arrow_downward, color: Colors.grey),
        Card(
          color: Colors.blueGrey[800],
          child: ListTile(
            leading: const Icon(Icons.water, color: Colors.cyanAccent),
            title: const Text("Step 3: 胸管置入 (Chest Tube)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text("位置: 4-5th ICS 腋中線。\n方向: 排氣往「前上方」，排液往「後下方」。", style: TextStyle(color: Colors.white70)),
          ),
        ),
      ],
    );
  }

  // --- 4. Chest Tube Mgmt ---
  Widget _buildChestTubeCard() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("水封瓶冒泡 (Bubbling)", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            Text("• 意義: 空氣持續排出 (BPF: 支氣管肋膜廔管)。", style: TextStyle(color: Colors.white70)),
            Divider(color: Colors.white24),
            Text("抽吸的迷思 (Suction Strategy)", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            Text("• 剛插管: 可開 -20cmH2O 助肺擴張。", style: TextStyle(color: Colors.white70)),
            Text("• 持續漏氣 (Persistent Leak): 建議關閉抽吸 (Off Suction)！", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("• 理由: 負壓會把廔管「吸開」，阻礙癒合。", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // --- 5. Pearls ---
  Widget _buildPearlsCard() {
    return Card(
      color: Colors.grey[850],
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.content_cut, color: Colors.purpleAccent),
            title: const Text("皮下氣腫 (SubQ Emphysema)", style: TextStyle(color: Colors.white)),
            subtitle: const Text("若範圍擴大，務必追蹤 CXR 排除氣胸。氣腫本身通常無害。", style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.greenAccent),
            title: const Text("預防 Barotrauma", style: TextStyle(color: Colors.white)),
            subtitle: const Text("ARDS 病人設定 Plateau Pressure ≤ 30 cmH2O。", style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.blueAccent),
            title: const Text("鑑別診斷", style: TextStyle(color: Colors.white)),
            subtitle: const Text("單側呼吸音小？小心 Endo 滑入右主支氣管 (Right mainstem intubation)。", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}