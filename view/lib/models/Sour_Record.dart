class SourRecord {
  final String id;
  final String userId;
  final List<String> videos;
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
    var videosList = json['videos'];
    List<String> videos = [];
    if (videosList is List) {
      videos = List<String>.from(videosList.map((video) => video.toString()));
    } else if (videosList is String) {
      videos = [videosList];  // If it's a single string, convert it to a list with one item
    }


    return SourRecord(
      id: json['id'],
      userId: json['user_id'],
      videos: videos,
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