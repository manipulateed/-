import 'dart:convert';
class SourRecord {
  String id;
  String userId;
  List<String> videos;
  String title;
  String reason;
  String time;

  SourRecord({required this.id, required this.userId, required this.videos, required this.title, required this.reason, required this.time});

  String getSourRecordData() {
    Map<String, dynamic> recordData = {
      'id': this.id,
      'user_id': this.userId,
      'videos': this.videos,
      'title': this.title,
      'reason': this.reason,
      'time': this.time
    };
    return jsonEncode(recordData);
  }
}
