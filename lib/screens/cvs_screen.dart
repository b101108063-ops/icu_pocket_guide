// lib/screens/cvs_screen.dart
import 'package:flutter/material.dart';

class CvsScreen extends StatefulWidget {
  const CvsScreen({super.key});

  @override
  State<CvsScreen> createState() => _CvsScreenState();
}

class _CvsScreenState extends State<CvsScreen>
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
        title: const Text("CVS: AMI / IABP / ECMO"),
        backgroundColor: Colors.red[900], // 心臟相關用深紅
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "AMI Rx"),
            Tab(text: "IABP"),
            Tab(text: "ECMO"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAmiTab(), _buildIabpTab(), _buildEcmoTab()],
      ),
    );
  }

  // --- Tab 1: AMI Protocol ---
  Widget _buildAmiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader("1. 情境處置 (Scenario)"),

        // 情境 A: 急診轉入 (Post-Cath)
        Card(
          color: Colors.blueGrey[900],
          child: ExpansionTile(
            title: const Text(
              "Post-Cath 轉入 ICU",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            subtitle: const Text("已做完導管 (PCI)"),
            initiallyExpanded: true,
            children: [
              _buildCheckListTile("詳閱 Cath Note (血管病灶/處置)"),
              _buildCheckListTile("確認 DAPT 種類與劑量 (Aspirin + P2Y12)"),
              _buildCheckListTile("確認抗凝血劑 (Fondapurinux/Heparin) 天數"),
              _buildCheckListTile("確認 Echo: EF? Wall motion?"),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 情境 B: ICU 新診斷 (New Onset)
        Card(
          color: Colors.red[900]!.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: const Text(
              "ICU 新診斷 (New Onset)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: const Text("STEMI / NSTEMI"),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.phone_in_talk,
                  color: Colors.redAccent,
                ),
                title: const Text("緊急會診 CV Man"),
                subtitle: const Text("Record Time! (仿照 D2B 概念)"),
              ),
              ListTile(
                leading: const Icon(Icons.computer, color: Colors.redAccent),
                title: const Text("開立醫令組套"),
                subtitle: const Text("Acute infarction and post IV-tPA care"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader("2. 關鍵藥物確認 (Verify)"),
        _buildInfoCard(
          "DAPT (Anti-platelet)",
          "Aspirin + Plavix / Brilinta / Efient",
        ),
        _buildInfoCard("Anti-coagulant", "Fondapurinux vs Heparin (計畫用幾天?)"),
      ],
    );
  }

  // --- Tab 2: IABP Protocol (重點工具) ---
  Widget _buildIabpTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. 原理與波形 (Principles)
        _buildSectionHeader("1. 原理與波形 (Principles)"),
        Card(
          color: Colors.grey[900],
          child: ExpansionTile(
            leading: const Icon(
              Icons.waves,
              color: Colors.orangeAccent,
              size: 32,
            ),
            title: const Text(
              "反搏作用 (Counter-pulsation)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: const Text("充氣增灌流 / 洩氣降負荷"),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 這裡適合放入波形圖
                    const Text(
                      "",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(height: 8),
                    _buildPrincipleRow(
                      "充氣 (Inflation)",
                      "舒張期 (Diastole)",
                      "增加冠狀動脈灌流\n(Augmented Diastolic Pressure)",
                      Colors.greenAccent,
                    ),
                    const Divider(height: 24),
                    _buildPrincipleRow(
                      "洩氣 (Deflation)",
                      "收縮期前 (Pre-Systole)",
                      "產生負壓，降低 Afterload\n(End-diastolic dip)",
                      Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. 初始設定 (Initial Setup)
        _buildSectionHeader("2. 初始設定 (Setup & Orders)"),
        Card(
          color: Colors.blueGrey[900],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.image, color: Colors.white),
                  title: const Text("CXR 位置確認"),
                  subtitle: const Text(
                    "Tip @ Lt 2nd-3rd ICS\n(Aortic Knob 下 2cm)",
                  ),
                  trailing: const Text(
                    "",
                    style: TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.timer, color: Colors.white),
                  title: Text("監測醫令"),
                  subtitle: Text(
                    "• Doppler check distal pulse Q2H\n• Check aPTT Q6H",
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 3. Heparin Protocol (核心工具)
        _buildSectionHeader("3. Heparin Protocol (15000u/500ml)"),
        Card(
          color: Colors.grey[850],
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.teal[900],
                child: const Column(
                  children: [
                    Text(
                      "標準配方: 15,000 U in 500 ml NS",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Start Rate: 21 ml/hr (先 Bolus 3cc)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Titration Table
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey[700]!,
                      width: 0.5,
                    ),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1.2), // aPTT
                    1: FlexColumnWidth(1.5), // Action
                    2: FlexColumnWidth(1.2), // Rate
                  },
                  children: [
                    _buildTableHeader(),
                    _buildHeparinRow(
                      "< 40",
                      "Bolus 3000",
                      "+ 4 ml/hr",
                      Colors.redAccent,
                    ),
                    _buildHeparinRow(
                      "40 - 49",
                      "-",
                      "+ 4 ml/hr",
                      Colors.orangeAccent,
                    ),
                    _buildHeparinRow(
                      "50 - 75",
                      "Target (Keep)",
                      "維持",
                      Colors.greenAccent,
                    ),
                    _buildHeparinRow(
                      "76 - 85",
                      "-",
                      "- 4 ml/hr",
                      Colors.orangeAccent,
                    ),
                    _buildHeparinRow(
                      "86 - 100",
                      "Hold 30 min",
                      "- 4 ml/hr",
                      Colors.redAccent,
                    ),
                    _buildHeparinRow(
                      "> 101",
                      "Hold 60 min",
                      "- 8 ml/hr",
                      Colors.red[900]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 4. Weaning & Removal
        _buildSectionHeader("4. 移除步驟 (Removal)"),
        Card(
          color: Colors.red[900]!.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent),
          ),
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.warning, color: Colors.redAccent),
                title: Text("關鍵禁忌 (Safety)"),
                subtitle: Text("需停用 Heparin 2 小時後再拔除！\n(避免傷口血流不止)"),
              ),
              const Divider(color: Colors.redAccent),
              const ListTile(
                leading: Icon(Icons.eject, color: Colors.white),
                title: Text("Weaning Steps"),
                subtitle: Text("1:1 → 1:2 → 1:4 → 1:8\n(不需等升壓藥全停)"),
              ),
              const ListTile(
                leading: Icon(Icons.opacity, color: Colors.white),
                title: Text("止血技巧"),
                subtitle: Text("拔除時讓血流出一點 (Flush out clots)\n再強力加壓止血"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Tab 3: ECMO / Shock ---
  // --- Tab 3: ECMO / Shock (全面升級版) ---
  Widget _buildEcmoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. 啟動與會診
        _buildSectionHeader("1. 啟動流程 (Activation)"),
        Card(
          color: Colors.teal[900],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(
                    Icons.phone_in_talk,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: Text("CVS ECMO Team"),
                  subtitle: Text("分機: 8-8066\n(需先經 VS 同意)"),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black26,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.yellowAccent,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "由 CVS Team 解釋病情，家屬同意後執行",
                          style: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 2. 模式與適應症
        _buildSectionHeader("2. 模式選擇 (Modes)"),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                "V-V ECMO",
                Icons.air,
                Colors.lightBlueAccent,
                "Lung Failure Only",
                "Fem V. → IJ V.\n(無 Cardiac Arrest 風險)",
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildModeCard(
                "V-A ECMO",
                Icons.favorite,
                Colors.redAccent,
                "Heart + Lung Failure",
                "Fem V. → Fem Art.\n(有 Arrest 風險)",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 插入示意圖標籤，讓醫師能快速理解插管位置
        const Text(
          "",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 16),

        // 3. 每日照護目標 (Daily Goals)
        _buildSectionHeader("3. 照護目標 (Daily Goals)"),
        Card(
          color: Colors.grey[900],
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  "Sedation (鎮靜)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
                subtitle: Text("Total Sedation (避免管路拉扯)"),
                dense: true,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    _buildTargetBox("aPTT", "50 - 70", "sec"),
                    _buildTargetBox("ACT", "180 - 200", "sec"),
                    _buildTargetBox("Hct", "> 35", "%"),
                    _buildTargetBox("PLT", "> 50k", "/uL"),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 4. 異常排除 (Troubleshooting) - 這是救命的
        _buildSectionHeader("4. Flow 下降排除流程"),
        Card(
          color: Colors.red[900]!.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🚨 Flow Drop Algorithm",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStepRow("1", "檢查管路是否 Kinking (折到)"),
                _buildStepRow("2", "檢查 CVP Level (是否太低?)"),
                _buildStepRow("3", "Hypovolemia? (給水/輸血)"),
                _buildStepRow("4", "調整床位 (試著躺平增加回流)"),
                const Divider(color: Colors.redAccent),
                const Row(
                  children: [
                    Icon(Icons.phone, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "無法解決 → Call 體循師",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 5. 禁忌症 (Contraindications)
        const ExpansionTile(
          title: Text(
            "絕對禁忌症 (Contraindications)",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          children: [
            ListTile(title: Text("• 年齡 > 80 歲")),
            ListTile(title: Text("• 多重器官衰竭 (MOF)")),
            ListTile(title: Text("• Unknown cause CPR 或 CPR > 6 mins")),
            ListTile(title: Text("• 嚴重腦傷 (ICH) / 末期惡性腫瘤")),
            ListTile(title: Text("• 無法控制的敗血症或出血")),
            ListTile(title: Text("• 嚴重 PAOD (V-A 禁忌)")),
          ],
        ),

        const SizedBox(height: 10),

        // 6. 脫離指標
        Card(
          color: Colors.grey[850],
          child: const ExpansionTile(
            title: Text(
              "脫離指標 (Weaning Signs)",
              style: TextStyle(color: Colors.greenAccent),
            ),
            children: [
              ListTile(
                title: Text("V-A ECMO"),
                subtitle: Text("強心劑調降 + Pulse Pressure 拉大\n(代表心臟自己在跳)"),
              ),
              ListTile(
                title: Text("V-V ECMO"),
                subtitle: Text("Flow & FiO2 下調 + CXR 改善"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 新增的 Helper Widgets (請加在 _CvsScreenState 類別內底部) ---

  Widget _buildModeCard(
    String title,
    IconData icon,
    Color color,
    String type,
    String cannulation,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              type,
              style: const TextStyle(fontSize: 10, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Colors.grey),
            Text(
              cannulation,
              style: const TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(String step, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.redAccent,
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCheckListTile(String title) {
    return ListTile(
      leading: const Icon(Icons.check_box_outline_blank, color: Colors.grey),
      title: Text(title),
      dense: true,
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          content,
          style: const TextStyle(color: Colors.cyanAccent),
        ),
      ),
    );
  }

  // ✅ 保留這個新版的 (3個參數)
  Widget _buildTargetBox(String label, String value, String unit) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  // 1. 原理圖解的小元件
  Widget _buildPrincipleRow(
    String phase,
    String timing,
    String effect,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 40,
          color: color,
          margin: const EdgeInsets.only(right: 12, top: 2),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phase,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
              Text(
                "時機: $timing",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(effect, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  // 2. 表格標題
  TableRow _buildTableHeader() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("aPTT", style: TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Action", style: TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Rate",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // 3. 表格內容列
  TableRow _buildHeparinRow(
    String aptt,
    String action,
    String rate,
    Color color,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            aptt,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(action, style: const TextStyle(color: Colors.white70)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            rate,
            textAlign: TextAlign.right,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // =============================================================
}
