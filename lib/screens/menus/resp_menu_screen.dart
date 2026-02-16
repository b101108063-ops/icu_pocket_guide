// lib/screens/menus/resp_menu_screen.dart
import 'package:flutter/material.dart';
import '../ards_screen.dart';
import '../lung_screen.dart';
import '../copd_asthma_screen.dart';
import '../pe_screen.dart';
import '../resp_procedure_screen.dart';
import '../pulm_edema_screen.dart';
import '../pneumo_screen.dart';
import '../pleural_screen.dart'; // <--- 1. 加入這行

class RespMenuScreen extends StatelessWidget {
  const RespMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8, // <--- 2. 改成 8 個 Tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Respiratory System'),
          backgroundColor: Colors.blueAccent[700],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "ARDS"),
              Tab(text: "Pneumonia"),
              Tab(text: "COPD/Asthma"),
              Tab(text: "Pulm Edema"),
              Tab(text: "Pneumothorax"),
              Tab(text: "Effusion"), // <--- 3. 新增這個 Tab (肋膜積水)
              Tab(text: "PE / Vasc"),
              Tab(text: "Vent/Procs"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: const TabBarView(
          children: [
            ArdsScreen(),
            LungScreen(),
            CopdAsthmaScreen(),
            PulmEdemaScreen(),
            PneumoScreen(),
            PleuralScreen(), // <--- 4. 對應頁面
            PeScreen(),
            RespProcedureScreen(),
          ],
        ),
      ),
    );
  }
}
