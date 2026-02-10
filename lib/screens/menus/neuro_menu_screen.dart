import 'package:flutter/material.dart';
import '../sedation_screen.dart';

class NeuroMenuScreen extends StatelessWidget {
  const NeuroMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Neurological System'),
          backgroundColor: Colors.deepPurpleAccent[700],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "Sedation/PAD"),
              Tab(text: "Stroke"),
              Tab(text: "Seizure"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: TabBarView(
          children: [
            const SedationScreen(), // 這是我們唯一完成的詳細頁
            _buildPlaceholder("Stroke Protocol\n(Coming Soon)"),
            _buildPlaceholder("Seizure/Status\n(Coming Soon)"),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey, fontSize: 18),
      ),
    );
  }
}
