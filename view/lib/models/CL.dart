import 'dart:convert';

class CollectList {
  String id;
  String userId;
  String name;
  List<String> collection;

  CollectList({
    required this.id,
    required this.userId,
    required this.name,
    required this.collection,
  });

  factory CollectList.fromJson(String jsonString) {
    try {
      // 將傳入的 JSON 字符串解析為 Map<String, dynamic>
      Map<String, dynamic> json = jsonDecode(jsonString);

      // 嘗試解析 collection 字段
      String collectionStr = json['collection'] as String;
      List<String> collectionList = [];
      if (collectionStr.isNotEmpty && collectionStr != "[]") {
        // 解析 collection 字符串為 JSON 列表
        collectionList = List<String>.from(jsonDecode(collectionStr.replaceAll(RegExp(r"\'"), "\"")));
      }

      // 返回 CollectList 物件
      return CollectList(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String,
        collection: collectionList,
      );
    } catch (e) {
      // 處理解析錯誤
      print('Error parsing item: $jsonString');
      throw Exception('Invalid response format');
    }
  }



// factory CollectList.fromJson(Map<String, dynamic> json) {
//     // 處理 collection 欄位為 List<String>
//     List<String> parseCollection(String collectionField) {
//       // 使用正則表達式去除 ObjectId 的部分，只保留實際的 ID
//       RegExp regExp = RegExp(r"ObjectId\('(.+?)'\)");
//       Iterable<RegExpMatch> matches = regExp.allMatches(collectionField);
//       return matches.map((match) => match.group(1)!).toList();
//     }

//     return CollectList(
//       id: json['id'] as String,
//       userId: json['user_id'] as String,
//       name: json['name'] as String,
//       collection: parseCollection(json['collection'] as String),
//     );
//   }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'collection': jsonEncode(collection),
    };
  }
  // // Helper methods to update name and manage videos
  // Future<bool> updateName(Helper helper, String newName) async {
  //   name = newName;
  //   return await helper.updateCLData(id, 'name', newName);
  // }

  // Future<bool> addVideo(Helper helper, String videoId) async {
  //   collection = videoId;
  //   return await helper.updateCLData(id, 'add_video', videoId);
  // }

  // Future<bool> removeVideo(Helper helper, String videoId) async {
  //   return await helper.updateCLData(id, 'remove_video', videoId);
  // }

  String getCLData() {
    Map<String, dynamic> clData = {
      "id": id,
      "user_id": userId,
      "name": name,
      "collection": collection
    };
    return jsonEncode(clData);
  }
}

