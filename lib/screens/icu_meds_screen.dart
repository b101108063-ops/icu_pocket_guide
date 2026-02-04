import 'package:flutter/material.dart';

class ErMedsScreen extends StatelessWidget {
  const ErMedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ER / ICU Medications'),
        backgroundColor: Colors.red[900], // 使用紅色系代表急救/警示
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. 最上方的警示卡 (Intro)
          _buildWarningCard(),
          const SizedBox(height: 16),

          // A. 抗心律不整
          _buildSectionHeader("A. 抗心律不整 (Antiarrhythmic)"),
          _buildDrugCard("Adenosine", "6mg/2ml", [
            "用法: IV rapid push (1-3s) + N/S 20ml flush",
            "劑量: 6mg ⮕ 無效 ⮕ 12mg ⮕ 12mg (Max 30mg)",
            "監測: 會有一過性 Asystole，需接 monitor",
          ], Colors.redAccent),
          _buildDrugCard("Amiodarone", "150mg/3ml", [
            "⚠️ 泡製: 僅限用 D5W (N/S 會沈澱)",
            "Loading: 150mg / 100ml D5W run 10 min",
            "Maint: 360mg / 6hr (1mg/min) ⮕ 540mg / 18hr (0.5mg/min)",
          ], Colors.redAccent),
          _buildDrugCard("Lidocaine", "100mg/5ml", [
            "Bolus: 50-100 mg (1-1.5 mg/kg) IV push",
            "Drip: 5 amp + D5W 75ml (Total 100ml) ⮕ 1-4 mg/min",
          ], Colors.redAccent),
          _buildDrugCard("Digoxin", "0.25mg/1ml", [
            "Loading: Total 10 mcg/kg (先給一半，之後每6-8hr給剩餘)",
            "Maint: 0.125 - 0.25 mg QD",
            "監測: 腎功能、K/Mg/Ca (低血鉀易中毒)",
          ], Colors.orangeAccent),

          const SizedBox(height: 16),

          // B. 升壓與強心
          _buildSectionHeader("B. 升壓與強心 (Pressors/Inotropes)"),
          _buildDrugCard("Norepinephrine (Levophed)", "4mg/4ml (常見規格)", [
            "泡製: 2 amp (8mg) + D5W 92ml (Total 100ml, 80 mcg/ml)",
            "劑量: Start 0.1 - 0.2 mcg/kg/min",
            "作用: α > β1 (敗血性休克首選)",
          ], Colors.tealAccent),
          _buildDrugCard("Dopamine", "200mg/5ml", [
            "泡製: 2 amp (400mg) + D5W 500ml (800 mcg/ml)",
            "劑量: 2-20 mcg/kg/min",
            "作用: 腎血流(1-3) ⮕ 強心(3-10) ⮕ 升壓(10-20)",
          ], Colors.tealAccent),
          _buildDrugCard("Dobutamine", "250mg/5ml", [
            "泡製: 1 amp (250mg) + D5W 100ml (2.5 mg/ml)",
            "劑量: 2-20 mcg/kg/min",
            "作用: β1 > β2 (強心為主，可能掉血壓)",
          ], Colors.tealAccent),
          _buildDrugCard("Epinephrine (Bosmin)", "1mg/1ml", [
            "急救: 1mg IV push (q3-5min)",
            "Drip: 1 amp + D5W 250ml (4 mcg/ml)。Start 1-4 mcg/min",
          ], Colors.tealAccent),

          const SizedBox(height: 16),

          // C. 降壓與血管擴張
          _buildSectionHeader("C. 降壓與血管擴張 (Anti-HTN)"),
          _buildDrugCard("Nitroglycerin (NTG)", "50mg/10ml", [
            "劑量: Start 10 mcg/min (約 3 ml/hr)，每 5-10 分鐘上調",
            "作用: 擴張靜脈 > 動脈 (降 Preload)",
          ], Colors.purpleAccent),
          _buildDrugCard("Nitroprusside (Nipride)", "50mg/vial", [
            "泡製: 1 vial (50mg) + D5W 250ml",
            "劑量: Start 0.3 - 0.5 mcg/kg/min",
            "⚠️ 警示: 需避光。注意 Cyanide 中毒 (酸中毒為早期徵兆)",
          ], Colors.purpleAccent),
          _buildDrugCard("Nicardipine (Perdipine)", "10mg/10ml", [
            "泡製: 6 amp + D5W 100ml (0.6 mg/ml)",
            "劑量: Start 1 mcg/kg/min (約 6ml/hr)",
          ], Colors.purpleAccent),
          _buildDrugCard("Labetalol (Trandate)", "25mg/5ml", [
            "Bolus: 10-20 mg slow push (可重複給)",
            "Drip: Start 15-20 ml/hr (1mg/ml)。Max 160mg/hr",
          ], Colors.purpleAccent),

          const SizedBox(height: 16),

          // D. 其他
          _buildSectionHeader("D. 電解質與其他"),
          _buildDrugCard("Magnesium Sulfate", "2g/20ml (10%)", [
            "Torsades: 1-2g 稀釋後 IV bolus (5-60min)",
            "Hypomagnesemia: 1-2g in 100ml D5W run 1-2hr",
          ], Colors.lightBlueAccent),
          _buildDrugCard("Milrinone (Primacor)", "10mg/10ml", [
            "Loading: 50 mcg/kg (>10min)",
            "Maint: 0.375 - 0.75 mcg/kg/min",
            "機轉: PDE3 inhibitor (強心+擴管)",
          ], Colors.lightBlueAccent),

          const SizedBox(height: 30),
          const Center(
            child: Text(
              "⚠️ 各醫院 Pump 泡法與規格可能不同，請務必核對單位。",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildWarningCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orangeAccent),
                SizedBox(width: 8),
                Text(
                  "重要使用須知",
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
              "1. 泡製濃度: 各醫院 Pump 泡法可能不同，請務必核對單位 (ug/kg/min 或 ml/hr)。",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 4),
            Text(
              "2. Amiodarone: 僅可用 D5W 稀釋，禁用 N/S (會沈澱)。",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              "3. Adenosine: 半衰期極短，需 IV push fast (1-3秒) 並立即推 N/S。",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 4),
            Text(
              "4. Nitroprusside: 需避光，長期使用需監測 Cyanide 中毒。",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey[400]!, width: 4)),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDrugCard(
    String drugName,
    String spec,
    List<String> details,
    Color accentColor,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    drugName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    spec,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            ...details.map((detail) {
              // 簡單的關鍵字高亮處理 (這裡主要處理 "劑量", "泡製" 等詞)
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(color: Colors.grey)),
                    Expanded(
                      child: Text(
                        detail,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
