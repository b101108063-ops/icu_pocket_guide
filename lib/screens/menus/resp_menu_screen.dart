import 'package:flutter/material.dart';
import '../ards_screen.dart';
import '../lung_screen.dart';
import '../resp_procedure_screen.dart';

class RespMenuScreen extends StatelessWidget {
  const RespMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Respiratory System'),
          backgroundColor: Colors.blueAccent[700],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "ARDS"),
              Tab(text: "Lung Dz"), // 肺炎/COPD
              Tab(text: "Vent/Procs"), // 呼吸器/管路
            ],
          ),
        ),
        // 使用深色背景，避免切換時閃爍白光
        backgroundColor: Colors.grey[900],
        body: const TabBarView(
          children: [ArdsScreen(), LungScreen(), RespProcedureScreen()],
        ),
      ),
    );
  }
}
