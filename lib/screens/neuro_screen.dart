import 'package:flutter/material.dart';

class SedationScreen extends StatelessWidget {
  const SedationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900], // 深色背景
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 引言區塊
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.deepPurpleAccent),
            ),
            child: const Text(
              "原則：先止痛 (Analgesia) ⮕ 再鎮靜 (Sedation) ⮕ 後譫妄 (Delirium)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // --- Step 1: Pain Control ---
          _buildStepHeader("Step 1", "Pain Control (止痛)", Icons.healing),

          // 這裡呼叫了 _buildCard，錯誤就會消失
          _buildCard(
            title: "評估工具 (Assessment)",
            content: [
              "• NRS (清楚者): 0-10 分",
              "• BPS (插管者): 3-12 分 (評估表情、上肢、呼吸器配合)",
            ],
            color: Colors.purple[900]!,
          ),

          _buildDrugCard(
            "Fentanyl Pump (首選)",
            "配製: 1000 mcg (20ml) + N/S 80ml \n(Total 100ml, 10 mcg/ml)",
            [
              "給藥指引: 若 NRS 5-6 或 BPS 9-10",
              "Bolus: 5 ml (50 mcg)",
              "Infusion: 5 ml/hr (50 mcg/hr)",
              "範圍: 12.5 - 150 mcg/hr",
            ],
            Colors.purpleAccent,
          ),

          const SizedBox(height: 24),

          // --- Step 2: Agitation / Sedation ---
          _buildStepHeader("Step 2", "Sedation (鎮靜)", Icons.nights_stay),

          // 這裡也呼叫了 _buildCard
          _buildCard(
            title: "目標 (RASS Score)",
            content: ["• 一般病人: -2 (輕度鎮靜) ~ +1 (清醒)", "• ARDS: -3 ~ -4 (中重度鎮靜)"],
            color: Colors.indigo[900]!,
          ),

          _buildCard(
            title: "標準 BZD 階梯 (Standard)",
            content: [
              "• RASS > 0 時: Lorazepam 2mg 或 Midazolam 5mg IV push q15m",
              "• 1hr 後無效: 改 Pump infusion",
              "  - Lorazepam: 2mg/4ml, run 1ml/hr",
              "  - Midazolam: 15mg/3ml, run 1ml/hr",
            ],
            color: Colors.indigo[900]!,
          ),

          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              "特殊藥物 (Specific Agents)",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _buildDrugCard(
            "Dexmedetomidine (Precedex)",
            "配製: 200 mcg/2ml + N/S 48ml \n(Total 50ml, 4 mcg/ml)",
            [
              "適應症: 拔管前鎮靜 (Pre-extubation)",
              "劑量: Maintain 0.2 - 1.5 mcg/kg/hr",
              "用法: 通常 run 2 ml/hr，不需 Loading",
              "特點: 不抑制呼吸、輕度止痛、少譫妄",
              "⚠️ 副作用: 低血壓、心跳過慢",
              "健保: 限短期 < 24hr 使用",
            ],
            Colors.tealAccent,
          ),

          _buildDrugCard("Propofol", "規格: 1% (10mg/ml), 含熱量", [
            "適應症: 神經重症、需頻繁評估意識 (Onset快)",
            "劑量: 0.3 - 3 mg/kg/hr (常見 1-25 ml/hr)",
            "⚠️ 禁忌: 對蛋、豆、奶、花生過敏者",
            "⚠️ 監測 PRIS (>5mg/kg/hr 或 >48hr):",
            "   代謝性酸中毒、高血鉀、橫紋肌溶解、心律不整",
          ], Colors.lightBlueAccent),

          const SizedBox(height: 24),

          // --- Step 3: Delirium ---
          _buildStepHeader("Step 3", "Delirium (譫妄)", Icons.psychology),

          _buildCard(
            title: "CAM-ICU 評估 (需符合 1+2 且 3或4)",
            content: [
              "1. 意識狀態急性改變 (Acute change)",
              "2. 注意力不集中 (Inattention)",
              "3. 意識程度改變 (RASS 非 0)",
              "4. 無組織思考 (Disorganized thinking)",
            ],
            color: Colors.brown[900]!,
          ),

          _buildDrugCard("藥物處置 (CAM-ICU Positive)", "需先治療原發疾病/誘發因子", [
            "Haloperidol: 5 mg IM q30min PRN (Max 35mg/day)",
            "Seroquel (Quetiapine): 25 mg PO BID",
          ], Colors.orangeAccent),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- Helper Widgets (工具函式區) ---

  // 1. 步驟標題工具
  Widget _buildStepHeader(String step, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step,
                style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. 一般資訊卡片工具 (這就是您原本缺少的引用)
  Widget _buildCard({
    required String title,
    required List<String> content,
    required Color color,
  }) {
    return Card(
      color: color.withOpacity(0.6),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(color: Colors.white24),
            ...content.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  e,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 藥物卡片工具
  Widget _buildDrugCard(
    String drugName,
    String spec,
    List<String> details,
    Color accentColor,
  ) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: accentColor.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              drugName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              spec,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white60,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Divider(color: Colors.white24),
            ...details.map((detail) {
              bool isWarning = detail.contains("⚠️");
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        color: isWarning ? Colors.red : Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        detail,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: isWarning ? Colors.red[100] : Colors.white,
                        ),
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
