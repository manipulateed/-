import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Video.dart';
import 'package:view/services/login_svs.dart';
import 'package:view/constants/config.dart';

class CallGPT_SVS{
    String message = "";
    Map<String, dynamic> response = {};
    List<Map<String, List<Video>>> suggestMap = [];
    String finish = "no";
    CallGPT_SVS({required this.message});

    //取得相關資訊
    final String baseUrl = Config.baseUrl;

    Future<void> getDignose(String CR_id) async{
      String token =  await Login_SVS.getStoredToken();
      final url = Uri.parse('${baseUrl}/diagnose');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "user_input": message,
          "CR_id": CR_id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        finish = parsedData["end"].toString();
        this.response = parsedData['response'];

        if (parsedData["end"].toString() =="True"){
          suggestMap = List<Map<String, List<Video>>>.from(
            (parsedData['Suggested_Videos'] as List).map((item) {
              Map<String, dynamic> mapItem = item as Map<String, dynamic>;
              List<dynamic> videoIds = mapItem['Video_id'] as List<dynamic>;

              return {
                mapItem['Keyword'] as String: List<Video>.from(
                    videoIds.map((id) => Video(id: id.toString()))
                ),
              };
            }),
          );
          print(suggestMap);
          this.response = parsedData['response'];
          print('SuggestVideos get successfully: ${this.suggestMap}');
        }
        print('Data get successfully: ${this.response}');
      } else {
        print('Failed to get data: ${response.statusCode}');
      }
    }



}