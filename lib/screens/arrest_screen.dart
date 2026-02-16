// lib/screens/arrest_screen.dart
import 'package:flutter/material.dart';

class ArrestScreen extends StatelessWidget {
  const ArrestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cardiac Arrest & TTM'),
          backgroundColor: Colors.red[900],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "ACLS/CPR"),
              Tab(text: "5H5T"),
              Tab(text: "TTM/Post"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: const TabBarView(children: [_AclsTab(), _FiveHTTab(), _TtmTab()]),
      ),
    );
  }
}

// --- Tab 1: ACLS & CPR ---
class _AclsTab extends StatelessWidget {
  const _AclsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 高品質 CPR 指標"),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildRow("深度/速率", "5-6 cm, 100-120/min", Colors.greenAccent),
                _buildRow(
                  "ETCO2",
                  "< 10 mmHg: 品質差\n> 40 mmHg: ROSC!",
                  Colors.yellowAccent,
                ),
                _buildRow(
                  "POCUS",
                  "看 Cardiac Standstill (預後差)\n排除 Tamponade/Pneumothorax",
                  Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. 流程與藥物 (Algorithm)"),
        _buildExpTile(
          "⚡ Shockable (VF / pVT)",
          [
            "1. 電擊 (Biphasic 200J) -> CPR 2min",
            "2. 電擊 -> CPR -> Epinephrine 1mg (q3-5m)",
            "3. 電擊 -> CPR -> Amiodarone 300mg",
            "4. Amiodarone 第二劑 150mg",
          ],
          Icons.flash_on,
          Colors.redAccent,
        ),
        _buildExpTile(
          "🚫 Non-Shockable (PEA / Asystole)",
          ["1. 盡快給 Epinephrine 1mg IV", "2. 不電擊", "3. 重點在找 5H5T (原因)"],
          Icons.heart_broken,
          Colors.grey,
        ),
      ],
    );
  }
}

// --- Tab 2: 5H5T ---
class _FiveHTTab extends StatelessWidget {
  const _FiveHTTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "口訣：三低高鉀酸中毒，兩心兩肺毒藥物",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("5H (Hypo/Hyper)"),
        _buildHTile("Hypovolemia", "低血容", "創傷/脫水 -> 輸液/輸血", Colors.blueAccent),
        _buildHTile("Hypoxia", "缺氧", "氣道阻塞 -> 插管/高濃度氧", Colors.blueAccent),
        _buildHTile(
          "Hydrogen ion",
          "酸中毒",
          "DKA/Sepsis -> 良好CPR/Bicarbonate",
          Colors.blueAccent,
        ),
        _buildHTile(
          "Hypo/Hyper-K",
          "高/低血鉀",
          "高: Ca/Insulin/樹脂\n低: 補鉀 (小心)",
          Colors.blueAccent,
        ),
        _buildHTile("Hypothermia", "低體溫", "核心體溫低 -> 復溫", Colors.blueAccent),

        const SizedBox(height: 16),
        _buildHeader("5T (Tension/Toxins)"),
        _buildHTile(
          "Tension Pneumo",
          "張力氣胸",
          "單側無呼吸音 -> 針刺減壓",
          Colors.orangeAccent,
        ),
        _buildHTile(
          "Tamponade",
          "填塞",
          "Beck's triad -> 心包膜穿刺",
          Colors.orangeAccent,
        ),
        _buildHTile(
          "Toxins",
          "中毒",
          "解毒劑 (Ca/Glucagon/Lipid)",
          Colors.orangeAccent,
        ),
        _buildHTile(
          "Thrombosis (Pul)",
          "肺栓塞",
          "RV strain -> tPA/ECMO",
          Colors.orangeAccent,
        ),
        _buildHTile(
          "Thrombosis (Cor)",
          "心肌梗塞",
          "STEMI -> PCI",
          Colors.orangeAccent,
        ),
      ],
    );
  }
}

// --- Tab 3: TTM & Post-Care ---
class _TtmTab extends StatelessWidget {
  const _TtmTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. TTM 啟動標準"),
        Card(
          color: Colors.grey[850],
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  "適應症",
                  style: TextStyle(color: Colors.greenAccent),
                ),
                subtitle: const Text(
                  "ROSC < 24hr 且 意識不清 (GCS<8)",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                title: const Text(
                  "⚠️ 絕對禁忌",
                  style: TextStyle(color: Colors.redAccent),
                ),
                subtitle: const Text(
                  "活動性出血 (ICH / GI Bleeding)\n無法控制的心律不整/休克",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ListTile(
                title: const Text(
                  "目標溫度",
                  style: TextStyle(color: Colors.cyanAccent),
                ),
                subtitle: const Text(
                  "32-34°C 維持 24hr (或 36°C)",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildHeader("2. TTM 階段與電解質 (重點!)"),
        Card(
          color: Colors.cyan[900]!.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "📉 降溫期 (Induction)",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "• 離子進細胞 -> 低血鉀 (Hypo-K)",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "• Cold diuresis -> 脫水",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  "⏸ 維持期 (Maintenance)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "• 需 Total Sedation (Nimbex) 防顫抖",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  "📈 回溫期 (Rewarming)",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "• 離子跑出來 -> ⚠️ 高血鉀 (Hyper-K)",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "• 動作: 回溫前 8hr 停止補鉀！",
                  style: TextStyle(color: Colors.yellowAccent),
                ),
                Text(
                  "• 速度: 0.2-0.5°C/hr (慢)",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _buildHeader("3. 預後評估 (72hr後)"),
        _buildExpTile(
          "神經學預後不良指標",
          [
            "時間點: 鎮靜藥效退去且 > 72小時",
            "徵象: 無瞳孔反射、無角膜反射、M1-M2",
            "輔助: EEG (癲癇波)、Brain CT (瀰漫水腫)",
          ],
          Icons.psychology,
          Colors.purpleAccent,
        ),

        const SizedBox(height: 16),
        _buildHeader("4. 其他復甦目標"),
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildRow("SpO2", "94-98% (避免 Hyperoxia)", Colors.white),
                _buildRow("MAP", "65-75 mmHg (確保腦灌流)", Colors.white),
                _buildRow("PCI", "若 STEMI 應儘早會診", Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

// --- Common Helpers ---
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

Widget _buildRow(String label, String val, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          val,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ],
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

Widget _buildHTile(String title, String cn, String action, Color color) {
  return Card(
    color: Colors.grey[900],
    shape: RoundedRectangleBorder(
      side: BorderSide(color: color.withOpacity(0.3)),
    ),
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      dense: true,
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            "($cn)",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
      subtitle: Text(action, style: const TextStyle(color: Colors.white60)),
    ),
  );
}
