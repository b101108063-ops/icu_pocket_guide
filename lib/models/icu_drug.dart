// lib/models/icu_drug.dart

// 定義單位：mcg/kg/min, mcg/min 等
enum DripUnit { mcg_kg_min, mcg_min, mg_hr }

class ICUDrip {
  final String name;       // 藥名
  final double defaultMg;  // 預設劑量 (mg)
  final double defaultMl;  // 預設體積 (ml)
  final DripUnit unit;     // 使用單位

  ICUDrip({
    required this.name,
    required this.defaultMg,
    required this.defaultMl,
    required this.unit,
  });
}