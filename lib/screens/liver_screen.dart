// lib/screens/liver_screen.dart
import 'package:flutter/material.dart';

class LiverScreen extends StatefulWidget {
  const LiverScreen({super.key});

  @override
  State<LiverScreen> createState() => _LiverScreenState();
}

class _LiverScreenState extends State<LiverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // NAC Calculator
  final TextEditingController _weightController = TextEditingController();
  double? _loadDose, _secDose, _thirdDose;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateNac() {
    double w = double.tryParse(_weightController.text) ?? 0;
    if (w > 0) {
      if (w > 110) w = 110; // NAC 體重上限通常設為 100-110kg
      setState(() {
        _loadDose = w * 150;
        _secDose = w * 50;
        _thirdDose = w * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          Container(
            color: Colors.orange[900], // 肝臟用深橘/棕色
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: "Acute (ALF)"),
                Tab(text: "Chronic (ACLF)"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildAlfTab(), _buildAclfTab()],
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 1: Acute Liver Failure (ALF) ---
  Widget _buildAlfTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 定義與特徵", Colors.redAccent),
        Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "定義: 無肝病史 + 26週內發生:",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "1. INR ≥ 1.5",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "2. Encephalopathy (肝昏迷)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.white24),
                Text(
                  "死因: 腦水腫 (Cerebral Edema)。",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("2. Acetaminophen 解毒 (NAC)", Colors.greenAccent),
        Card(
          color: Colors.green.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.greenAccent.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "NAC 劑量計算機 (IV Protocol)",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "體重 (kg): ",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _calculateNac,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                      ),
                      child: const Text("計算"),
                    ),
                  ],
                ),
                if (_loadDose != null) ...[
                  const Divider(),
                  _buildDoseRow(
                    "1. Loading (1hr)",
                    "${_loadDose!.toStringAsFixed(0)} mg",
                    "in 200ml D5W",
                  ),
                  _buildDoseRow(
                    "2. Dose 2 (4hr)",
                    "${_secDose!.toStringAsFixed(0)} mg",
                    "in 500ml D5W",
                  ),
                  _buildDoseRow(
                    "3. Dose 3 (16hr)",
                    "${_thirdDose!.toStringAsFixed(0)} mg",
                    "in 1000ml D5W",
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHeader("3. 腦水腫處置", Colors.purpleAccent),
        _buildExpTile(
          "治療策略",
          [
            "頭高 30度。",
            "Hypertonic Saline: 維持 Na 145-155。",
            "CVVH: 若 Ammonia > 150 µmol/L 建議洗腎。",
          ],
          Icons.psychology,
          Colors.purpleAccent,
        ),
      ],
    );
  }

  // --- Tab 2: Acute-on-Chronic (ACLF) ---
  Widget _buildAclfTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader("1. 靜脈曲張出血 (EV Bleeding)", Colors.redAccent),
        _buildExpTile(
          "EV 三寶 (處置)",
          [
            "藥物: Terlipressin 1mg IV Q4-6H (首選)。",
            "抗生素: Ceftriaxone 1g QD (必備)。",
            "胃鏡: 12hr 內執行 EVL。",
            "目標: Hb 7-8 g/dL (勿過度輸血)。",
          ],
          Icons.bloodtype,
          Colors.redAccent,
        ),

        const SizedBox(height: 16),
        _buildHeader("2. 併發症管理", Colors.orangeAccent),
        _buildExpTile(
          "肝性腦病變 (HE)",
          [
            "Lactulose: 30-45ml Q1H 直到解便，維持軟便 2-3次/天。",
            "灌腸: 300ml Lactulose + 700ml 水。",
            "Rifaximin: 400mg TID (殺菌)。",
          ],
          Icons.mood_bad,
          Colors.orangeAccent,
        ), // Brain icon replacement

        _buildExpTile(
          "自發性腹膜炎 (SBP)",
          [
            "診斷: 腹水 PMN > 250。",
            "抗生素: Ceftriaxone。",
            "Albumin (重要!): D1 1.5g/kg -> D3 1g/kg (防腎衰)。",
          ],
          Icons.bug_report,
          Colors.yellowAccent,
        ),

        _buildExpTile(
          "肝腎症候群 (HRS)",
          [
            "定義: 擴容無效之 AKI。",
            "治療: Terlipressin + Albumin (20-40g/day)。",
            "替代: Norepinephrine + Albumin。",
          ],
          Icons.watch_off,
          Colors.blueAccent,
        ), // Kidney icon replacement

        const SizedBox(height: 16),
        _buildHeader("3. 臨床珍珠", Colors.grey),
        Card(
          color: Colors.grey[850],
          child: ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.yellow),
            title: const Text("INR 的迷思", style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              "INR 高不代表自發出血風險高 (因 Protein C 也低)。除非活動性出血或侵入處置，否則不需輸 FFP。",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helpers ---
  Widget _buildHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDoseRow(String label, String dose, String fluid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dose,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                fluid,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
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
        initiallyExpanded: true,
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
