import 'dart:convert';

class ChatRecord {
  String userId;
  List<String> message;
  List<String> suggestedVideoIds;
  String possibleReasons;
  String timestamp;

  ChatRecord({
    required this.userId,
    required this.message,
    required this.suggestedVideoIds,
    required this.possibleReasons,
    required this.timestamp,
  });

  String getChatRecordData() {
    Map<String, dynamic> chatrecordData = {
      'user_id': userId,
      'message': message,
      'suggested_video_ids': suggestedVideoIds,
      'possible_reasons': possibleReasons,
      'last_update_timestamp': timestamp,
    };
    return jsonEncode(chatrecordData);
  }

}

