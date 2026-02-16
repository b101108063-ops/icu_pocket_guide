// lib/screens/arrhythmia_screen.dart
import 'package:flutter/material.dart';

class ArrhythmiaScreen extends StatelessWidget {
  const ArrhythmiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. 核心原則警示
          _buildWarningCard(),
          const SizedBox(height: 16),

          // 2. 快速診斷流程 (Algorithm)
          _buildHeader("1. 快速識別與診斷 (Diagnosis Algorithm)"),
          _buildAlgorithmSection(),
          const SizedBox(height: 16),

          // 3. 常見心律不整處置 (Specific Management)
          _buildHeader("2. 特定處置 (Specific Management)"),
          _buildManagementSection(),
          const SizedBox(height: 16),

          // 4. 藥物劑量速查 (Drug Dosages)
          _buildHeader("3. 關鍵藥物速查 (Drug Dosages)"),
          _buildDrugSection(),
          const SizedBox(height: 16),

          // 5. 臨床珍珠 (Pearls)
          _buildPearlSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 1. 核心原則警示 ---
  Widget _buildWarningCard() {
    return Card(
      color: Colors.red[900]!.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent.withOpacity(0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.flash_on, color: Colors.yellowAccent),
                SizedBox(width: 8),
                Text(
                  "核心原則 (Golden Rule)",
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "1. Treat the Patient, Not the Monitor!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "2. Unstable (休克/胸痛/意識不清) ⮕ 立刻電擊 (Synchronized Cardioversion)！",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "3. 寬 QRS 心搏過速 (WCT) 預設視為 VT 處理。",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. 診斷流程 (Algorithm) ---
  Widget _buildAlgorithmSection() {
    return Column(
      children: [
        // Narrow QRS
        _buildAlgoCard(
          "Narrow QRS (≤ 0.12s)",
          "起源: AV node 以上",
          Colors.blueAccent,
          [
            _buildAlgoRow(
              "Regular (規則)",
              "• Sinus Tachycardia (P波正常)\n• PSVT (突發突止, 無P波)\n• Atrial Flutter (鋸齒波)",
            ),
            _buildAlgoRow(
              "Irregular (不規則)",
              "• Atrial Fibrillation (最常見, 無P波)\n• MAT (多源性P波, COPD常見)",
            ),
          ],
        ),
        //
        const SizedBox(height: 12),
        // Wide QRS
        _buildAlgoCard(
          "Wide QRS (> 0.12s)",
          "起源: 心室 或 SVT+Aberrancy",
          Colors.redAccent,
          [
            _buildAlgoRow(
              "Regular (規則)",
              "• Ventricular Tachycardia (VT)\n• SVT with Aberrancy (少見)",
            ),
            _buildAlgoRow(
              "Irregular (不規則)",
              "• Torsade de Pointes (扭轉波)\n• AF with WPW (危險!)",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlgoCard(
    String title,
    String subtitle,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(side: BorderSide(color: color, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Divider(color: Colors.white24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAlgoRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. 特定處置 ---
  Widget _buildManagementSection() {
    return Column(
      children: [
        // AF
        _buildExpTile("A. 心房顫動 (Atrial Fibrillation)", [
          "目標: Rate Control (<110) + Stroke Prevention",
          "Diltiazem (首選): 0.25 mg/kg IV bolus (約 20mg) -> 5-15 mg/hr。",
          "Amiodarone (心衰竭用): 150mg IV bolus -> 1mg/min x 6h -> 0.5mg/min x 18h。",
          "Beta-blocker (Metoprolol): 適用高腎上腺素狀態 (術後)。",
          "電擊 (Unstable): Synchronized 100-200J。若 >48hr 需排除血栓。",
        ], Colors.blueAccent),
        //

        // PSVT
        _buildExpTile("B. PSVT (陣發性室上速)", [
          "Step 1: 迷走神經刺激 (改良式 Valsalva)。",
          "Step 2: Adenosine (首選) 6mg fast push -> 12mg -> 12mg。",
          "注意: 氣喘禁用 Adenosine。會造成短暫 Asystole。",
        ], Colors.orangeAccent),
        //

        // VT
        _buildExpTile("C. 心室頻脈 (VT)", [
          "Unstable (休克/痛): Synchronized Cardioversion 100J。",
          "Stable: Amiodarone 150mg IV over 10min -> Infusion。",
          "Unknown Wide QRS: 視同 VT 治療！不可給 Verapamil (會死)。",
        ], Colors.redAccent),
        //

        // Torsades
        _buildExpTile("D. Torsade de Pointes", [
          "特徵: 多型性 VT，QT 延長。",
          "首選: Magnesium 1-2g IV (over 15min, 若 arrest 則 push)。",
          "處置: 補鉀 (>4.0)、補鎂 (>2.0)、停用 QT 延長藥物。",
        ], Colors.purpleAccent),
        //
      ],
    );
  }

  Widget _buildExpTile(String title, List<String> details, Color color) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        children: details
            .map(
              (d) => ListTile(
                dense: true,
                leading: const Icon(Icons.arrow_right, color: Colors.grey),
                title: Text(d, style: const TextStyle(color: Colors.white70)),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- 4. 藥物劑量 ---
  Widget _buildDrugSection() {
    return Column(
      children: [
        _buildDrugRow(
          "Adenosine",
          "6mg -> 12mg -> 12mg",
          "IV 快推 + 沖水 (PSVT首選)",
        ),
        _buildDrugRow(
          "Amiodarone",
          "150mg over 10min",
          "之後 1mg/min x6h (AF/VT用)",
        ),
        _buildDrugRow(
          "Diltiazem",
          "0.25 mg/kg (約20mg)",
          "之後 5-15 mg/hr (HFrEF禁用)",
        ),
        _buildDrugRow("Magnesium", "1-2 g IV", "Torsades 首選"),
        _buildDrugRow("Esmolol", "500mcg/kg load", "超短效，適用 Aortic Dissection"),
      ],
    );
  }

  Widget _buildDrugRow(String name, String dose, String note) {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              dose,
              style: const TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          note,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ),
    );
  }

  // --- 5. Pearls ---
  Widget _buildPearlSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "👨‍⚕️ 臨床珍珠 (Clinical Pearls):",
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "1. 在 ICU，Wide QRS Tachycardia 95% 是 VT。不要輕易當作 SVT with aberrancy，給錯藥會 VF。",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "2. AF 的隱形殺手是中風。非急需手術者，盡早評估抗凝血。",
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            "3. 難治型心律不整常伴隨低血鉀/低血鎂。補 K>4.0, Mg>2.0 是基本動作。",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

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
}
