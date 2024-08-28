import 'dart:convert';
import 'package:view/models/Video.dart';

class ChatRecord {
  String id;
  String userId;
  List<Map<String, String>> message;
  List<Map<String, List<Video>>> suggestedVideoIds;
  String name;
  String timestamp;
  String finish;

  ChatRecord({
    required this.id,
    required this.userId,
    required this.message,
    required this.suggestedVideoIds,
    required this.name,
    required this.timestamp,
    required this.finish
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'user_id': userId,
      'message': message.isNotEmpty
          ? message.map((msg) => Map<String, dynamic>.from(msg)).toList()
          : [], // 確保 message 為 List
      'suggested_videos': suggestedVideoIds.isNotEmpty
          ? suggestedVideoIds.map((item) {
              String keyword = item.keys.first;
              List<Video> videos = item[keyword] ?? [];

              return {
                'Keyword': keyword,
                'Video_id': videos.map((video) => video.toJson()).toList(),
              };
      }).toList()
      : [], // 確保 suggested_videos 為 List
  'name': name?? '',
  'last_update_timestamp': timestamp?? '',
  'finished': finish ?? '',
};
}

factory ChatRecord.fromJson(Map<String, dynamic> json) {
return ChatRecord(
id : json['id'],
userId: json['user_id'],
      message: List<Map<String, String>>.from(
        (json['message'] as List).map(
              (item) => Map<String, String>.from(item),
        ),
      ),
      suggestedVideoIds: List<Map<String, List<Video>>>.from(
        (json['suggested_videos'] as List).map((item) {
          Map<String, dynamic> mapItem = item as Map<String, dynamic>;
          List<dynamic> videoIds = mapItem['Video_id'] as List<dynamic>;

          return {
            mapItem['Keyword'] as String: List<Video>.from(
                videoIds.map((id) => Video(id: id.toString()))
            ),
          };
        }),
      ),
      name: json['name'],
      timestamp: json['last_update_timestamp'],
      finish: json['finished'],
    );
  }
}

