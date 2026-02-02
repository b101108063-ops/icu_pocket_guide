// lib/screens/aline_screen.dart
import 'package:flutter/material.dart';

class AlineScreen extends StatefulWidget {
  const AlineScreen({super.key});

  @override
  State<AlineScreen> createState() => _AlineScreenState();
}

class _AlineScreenState extends State<AlineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A-line & Hemodynamics"),
        backgroundColor: Colors.deepOrange[800], // 動脈血顏色
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepOrangeAccent,
          tabs: const [
            Tab(text: "Procedure"),
            Tab(text: "Waveform"),
            Tab(text: "Flotrac"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProcedureTab(),
          _buildWaveformTab(),
          _buildFlotracTab(),
        ],
      ),
    );
  }

  // --- Tab 1: Procedure & Safety ---
  Widget _buildProcedureTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. Femoral A-line 置放警示"),
        Card(
          color: Colors.red[900]!.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.dangerous, color: Colors.redAccent, size: 30),
                    SizedBox(width: 10),
                    Text(
                      "CRITICAL WARNING",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.redAccent),
                const Text(
                  "❌ 禁止使用 Dilator (擴張器)！",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "操作技巧：",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                const Text(
                  "類似 CVC 打法 (One way)，但 Guidewire 進去後，「直接」送入 CVC 管路即可。",
                ),
                const SizedBox(height: 12),
                const Text(
                  "⚠️ t-PA 病人絕對禁忌：",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                const Text("24小時內禁止打 A-line (易血流不止)。"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. Leveling & Zeroing (校正)"),
        Card(
          color: Colors.grey[900],
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.height, color: Colors.orangeAccent),
                title: Text("Transducer 位置"),
                subtitle: Text("需對齊 Aortic Root (4th ICS)"),
              ),
              Divider(height: 1),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _LevelingIndicator(
                      "太高 (Too High)",
                      "BP 被低估 (Low)",
                      Colors.blue,
                    ),
                    Icon(Icons.compare_arrows, color: Colors.grey),
                    _LevelingIndicator(
                      "太低 (Too Low)",
                      "BP 被高估 (High)",
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Tab 2: Waveform Interpretation ---
  Widget _buildWaveformTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "透過 Flush Test (Fast Flush) 觀察震盪",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 10),

        // 1. Normal
        _buildWaveformCard(
          "Normal Waveform",
          "正常波形",
          Colors.green,
          "• 有明顯 Dicrotic Notch\n• Flush 後出現 2 個 Oscillations",
          Icons.show_chart,
        ),

        // 2. Over-damping
        _buildWaveformCard(
          "Over-damping (過阻尼)",
          "波形變鈍 / Notch 消失",
          Colors.orange,
          "影響: SBP 低估 / DBP 高估\nFlush Test: 只有 1 個震盪",
          Icons.multiline_chart,
          trouble:
              "常見原因:\n• 氣泡 (Air bubbles)\n• 血塊 (Clots)\n• 管路折到 (Kinking)\n• 接頭鬆脫",
        ),

        // 3. Under-damping
        _buildWaveformCard(
          "Under-damping (欠阻尼)",
          "震盪過大 / 尖峰",
          Colors.redAccent,
          "影響: SBP 高估 (Overshooting) / DBP 低估\nFlush Test: 多個震盪 (Ringing)",
          Icons.ssid_chart, // 震盪圖示
          trouble: "常見原因:\n• 心跳過快 (Tachycardia)\n• 低體溫 (Hypothermia)\n• 血管硬化",
        ),
      ],
    );
  }

  // --- Tab 3: Flotrac & Hemodynamics ---
  Widget _buildFlotracTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("Flotrac Parameters"),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildParamCard(
              "SVV",
              "> 10-12 %",
              "Hypovolemia (欠水)",
              Colors.blueAccent,
            ),
            _buildParamCard(
              "CI",
              "3.0 - 5.0",
              "Cardiac Function",
              Colors.greenAccent,
            ),
            _buildParamCard(
              "SVRI",
              "1700 - 2400",
              "Afterload / Resistance",
              Colors.purpleAccent,
            ),
            _buildParamCard(
              "MAP",
              "> 65 mmHg",
              "Perfusion Pressure",
              Colors.orangeAccent,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Card(
          color: Colors.blueGrey,
          child: ListTile(
            leading: Icon(Icons.water_drop, color: Colors.blueAccent),
            title: Text("SVV 應用"),
            subtitle: Text(
              "若 SVV > 12% 代表對輸液有反應 (Fluid Responsiveness)，應給予 Fluid Challenge。",
            ),
          ),
        ),
      ],
    );
  }

  // --- Helpers ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.deepOrangeAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _LevelingIndicator(String pos, String effect, Color color) {
    return Column(
      children: [
        Text(pos, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          effect,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildWaveformCard(
    String title,
    String subtitle,
    Color color,
    String content,
    IconData icon, {
    String? trouble,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content, style: const TextStyle(fontSize: 15)),
                if (trouble != null) ...[
                  const Divider(height: 20),
                  const Row(
                    children: [
                      Icon(Icons.build, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "Troubleshooting:",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trouble,
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamCard(String title, String value, String desc, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            desc,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
