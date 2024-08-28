import 'package:view/models/Video.dart';
class SourRecord {
  final String id;
  final String userId;
  final List<Map<String, List<Video>>> videos;
  final String reason;
  final DateTime time;

  SourRecord({
    required this.id,
    required this.userId,
    required this.videos,
    required this.reason,
    required this.time,
  });

  factory SourRecord.fromJson(Map<String, dynamic> json) {
    return SourRecord(
      id: json['id'],
      userId: json['user_id'],
      videos: List<Map<String, List<Video>>>.from(
        (json['videos'] as List).map((item) {
          Map<String, dynamic> mapItem = item as Map<String, dynamic>;
          List<dynamic> videoIds = mapItem['Video_id'] as List<dynamic>;

          return {
            mapItem['Keyword'] as String: List<Video>.from(
                videoIds.map((id) => Video(id: id.toString()))
            ),
          };
        }),
      ),
      reason: json['reason'],
      time: DateTime.parse(json['time']), // 解析字符串为 DateTime 对象
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'videos': videos,
      'reason': reason,
      'time': time.toIso8601String(), // 将 DateTime 对象转换为字符串
    };
  }
}