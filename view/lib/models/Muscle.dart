import 'dart:convert';

class Muscle {
  String id;
  String name;
  String describe;
  String sourReason;

  Muscle({
    required this.id,
    required this.name,
    required this.describe,
    required this.sourReason,
  });

  // 靜態方法來模擬從區域ID獲取所有肌肉
  static Future<List<Muscle>> getAllMuscleByAreaId(String areaId) async {
    // 實現你的邏輯，例如從API或數據庫獲取數據
    // 這裡我們返回一個空列表作為佔位符
    return [];
  }

  // 獲取肌肉數據
  String getMuscleData() {
    Map<String, dynamic> muscleData = {
      "id": id,
      "name": name,
      "describe": describe,
      "sour_reason": sourReason
    };
    return jsonEncode(muscleData);
  }
}
