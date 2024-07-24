import 'dart:convert';

class MuscleArea {
  String id;
  String name;
  List<String> muscles;

  MuscleArea({
    required this.id,
    required this.name,
    required this.muscles,
  });

  // 靜態方法來模擬獲取所有肌肉區域
  static Future<List<MuscleArea>> getAllArea() async {
    // 實現你的邏輯，例如從API或數據庫獲取數據
    // 這裡我們返回一個空列表作為佔位符
    return [];
  }

  // 獲取肌肉區域數據
  String getMuscleData() {
    Map<String, dynamic> areaData = {
      "id": id,
      "name": name,
      "muscles": muscles,
    };
    return jsonEncode(areaData);
  }
}
