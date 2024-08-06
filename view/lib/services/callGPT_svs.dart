import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Video.dart';

class CallGPT_SVS{
    String message = "";
    Map<String, dynamic> response = {};
    List<Map<String, List<Video>>> suggestMap = [];
    String finish = "no";
    CallGPT_SVS({required this.message});

    Future<void> getDignose() async{
      final url = Uri.parse('http://172.20.10.3:8080/diagnose');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "user_input": message,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedData = jsonDecode(response.body);
        if (!parsedData["end"]){
          print(parsedData);
          this.response = parsedData['response'];
          print('Data create successfully: ${this.response}');
        }
        else{

        }
      } else {
        print('Failed to create data: ${response.statusCode}');
      }
    }



}