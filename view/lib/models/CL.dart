import 'dart:convert';

class CollectList {
  String id;
  String userId;
  String name;
  String collection;

  CollectList({
    required this.id,
    required this.userId,
    required this.name,
    required this.collection,
  });

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

