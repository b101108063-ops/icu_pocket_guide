// lib/utils/resp_calcs.dart

class RespCalcs {
  // 計算理想體重 (IBW)
  // 男性: (身高 - 80) * 0.7
  // 女性: (身高 - 70) * 0.6
  static double calculateIBW(double heightCm, bool isMale) {
    if (isMale) {
      return (heightCm - 80) * 0.7;
    } else {
      return (heightCm - 70) * 0.6;
    }
  }

  // 計算目標潮氣容積 (Target VT: 6ml/kg)
  static double calculateTargetVT(double ibw) {
    return ibw * 6;
  }

  // 計算每分通氣量目標 (MV: IBW * 100 ml) -> 回傳 L/min
  static double calculateTargetMV(double ibw) {
    return (ibw * 100) / 1000;
  }
}
