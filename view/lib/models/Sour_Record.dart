class SourRecord {
  final String id;
  final String userId;
  final String videos;
  final String title;
  final String reason;
  final DateTime time;

  SourRecord({
    required this.id,
    required this.userId,
    required this.videos,
    required this.title,
    required this.reason,
    required this.time,
  });

  factory SourRecord.fromJson(Map<String, dynamic> json) {
    return SourRecord(
      id: json['id'],
      userId: json['user_id'],
      videos: json['videos'],
      title: json['title'],
      reason: json['reason'],
      time: DateTime.parse(json['time']), // 解析字符串为 DateTime 对象
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'videos': videos,
      'title': title,
      'reason': reason,
      'time': time.toIso8601String(), // 将 DateTime 对象转换为字符串
    };
  }
}
