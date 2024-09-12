import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Video.dart';

class Video_SVS {

  late Video videos;
  final String baseUrl = 'http://172.20.10.3:8080';
  Video_SVS({required this.videos});
  
  Future<void> createVideo(String name, String url) async {
    final apiUrl = Uri.parse('${baseUrl}/api/video/create');
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'url': url,
      }),
    );

    if (response.statusCode == 201) {
      print('Video created successfully: ${response.body}');
    } else {
      print('Failed to create video: ${response.statusCode}');
    }
  }

  Future<void> getVideoById(String videoId) async {
    final apiUrl = Uri.parse('${baseUrl}/VideoController/get?video_id=$videoId');
    final response = await http.get(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(videoId);
    if (response.statusCode == 200) {
      Map<String, dynamic> parsedData = jsonDecode(response.body);
      Map<String, dynamic> responses = parsedData['response'];
      videos = Video.fromJson(responses);
      print('Video retrieved successfully: ${videos.toJson()}');
    } else {
      print('Failed to retrieve video: ${response.statusCode}');
    }
  }


  Future<void> searchAndCreateVideos(String keyword, int maxResults) async {
    final apiUrl = Uri.parse('${baseUrl}/api/video/search_and_create');
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'keyword': keyword,
        'max_results': maxResults,
      }),
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      print('Videos searched and created successfully: ${content["created_videos"]}');
    } else {
      print('Failed to search and create videos: ${response.statusCode}');
    }
  }
}
