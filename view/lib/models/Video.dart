import 'dart:convert';

class Video {
  String id;
  String name;
  String url;

  Video({
    required this.id,
    required this.name,
    required this.url,
  });

  // Helper method to create a video
  Future<void> createVideo() async {
    // Implement your logic here
  }

  // Helper method to remove a video
  Future<void> removeVideo() async {
    // Implement your logic here
  }

  // Static method to get all videos
  static Future<List<Video>> getAll() async {
    // Implement your logic here to fetch all videos
    // For now, return an empty list as a placeholder
    return [];
  }

  // Get video data as a JSON string
  String getVideoData() {
    Map<String, dynamic> videoData = {
      "id": id,
      "name": name,
      "url": url,
    };
    return jsonEncode(videoData);
  }
}
