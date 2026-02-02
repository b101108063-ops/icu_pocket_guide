// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // 引入剛剛寫的首頁

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICU Pocket Guide',
      debugShowCheckedModeBanner: false, // 去掉右上角的 debug 標籤
      // 設定全域主題：強制深色模式 (ICU Dark Mode)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // 背景純黑
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900], // AppBar 深灰
          elevation: 0,
        ),
      ),

      home: HomeScreen(), // 指定首頁
    );
  }
}
