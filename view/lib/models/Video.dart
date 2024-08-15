import 'dart:convert';

class Video {
  String id;
  String name = "";
  String url;

  Video({
    required this.id,
    this.name = "",
    this.url = "",
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
  Map<String, dynamic> getVideoData() {
    Map<String, dynamic> videoData = {
      "id": id,
      "name": name,
      "url": url,
    };
    return videoData;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name ?? "",
      'url': url?? ""
    };
  }
  
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      name: json['name'],
      url: json['url']
    );
  }
}
