import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Chat_Record.dart';
import 'package:view/models/User.dart';
import 'package:view/services/login_svs.dart';
import 'package:view/constants/config.dart';

class Chatrecord_SVS{

  List<ChatRecord> chatrecords = [];
  Chatrecord_SVS({required this.chatrecords});
  final String baseUrl = Config.baseUrl;
  late User user;
  late String token;

  Future<void> getAllChatRecords() async {
    token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/get_chat_records');
    final response = await http.get(
        url,
        headers:{'Authorization': 'Bearer $token',}
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> parsedData = jsonDecode(response.body);
      List<dynamic> responses = parsedData['response'];

      chatrecords = responses.map((data) {
        return ChatRecord.fromJson(data);
      }).toList();

      // // 打印结果
      // chatrecords.forEach((record) {
      //   print('User ID: ${record.userId}');
      //   print('Messages: ${record.message}');
      //   print('Suggested Videos: ${record.suggestedVideoIds}');
      //   print('Name: ${record.name}');
      //   print('Timestamp: ${record.timestamp}');
      // });

      print('Data get successfully');
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  Future<void> updateChatRecord() async {
    token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/update_chat_record');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        chatrecords[0].toJson(),
      ),
    );
    if (response.statusCode == 200) {
      print('Data update successfully');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  Future<void> createChatRecord() async {
    token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/create_chat_record');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        chatrecords.last.toJson(),
      ),
    );
    print(jsonEncode(
      chatrecords.last.toJson(),
    ));
    if (response.statusCode == 200) {
      print('Data create successfully');
    } else {
      print('Failed to create data: ${response.statusCode}');
    }
  }

  Future<void> deleteCR(String id) async {
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/delete_chat_record?id=${id}');
  
    final response = await http.delete(
      url,
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Data delete successfully');
    } else {
      print('Failed to delete data: ${response.statusCode}');
    }
  }
}