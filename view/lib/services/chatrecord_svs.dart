import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Chat_Record.dart';
import 'package:view/models/User.dart';
import 'package:view/models/Video.dart';

class Chatrecord_SVS{

  List<ChatRecord> chatrecords = [];
  Chatrecord_SVS({required this.chatrecords});
  final String baseUrl = 'http://172.20.10.3:8080';
  late User user;

  Future<void> getAllChatRecords() async {
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/get_chat_records?user_id=66435c496b52ed9b072dc0e4');
    final response = await http.get(
        url
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> parsedData = jsonDecode(response.body);
      List<dynamic> responses = parsedData['response'];

      chatrecords = responses.map((data) {
        return ChatRecord.fromJson(data);
      }).toList();

      // 打印结果
      chatrecords.forEach((record) {
        print('User ID: ${record.userId}');
        print('Messages: ${record.message}');
        print('Suggested Videos: ${record.suggestedVideoIds}');
        print('Name: ${record.name}');
        print('Timestamp: ${record.timestamp}');
      });

      //print('Data get successfully: ${content}');
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  Future<void> updateChatRecord() async {
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/update_chat_record?user_id=66435c496b52ed9b072dc0e4');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        chatrecords[0].toJson(),
      ),
    );
    if (response.statusCode == 200) {
      print('Data update successfully: ${ChatRecord.fromJson(jsonDecode(response.body)['response'])}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  Future<void> createChatRecord() async {
    final url = Uri.parse('${baseUrl}/Chat_Record_Controller/create_chat_record?user_id=66435c496b52ed9b072dc0e4');

    final response = await http.post(
      url,
      headers: <String, String>{
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
      print('Data create successfully: ${response}');
    } else {
      print('Failed to create data: ${response.statusCode}');
    }
  }

  // Future<void> deleteCL() async {
  //   final url = Uri.parse('${baseUrl}/Collect_List_Controller/remove_CL?cl_id=20');
  //
  //   final response = await http.delete(
  //     url,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Data create successfully: ${response.body}');
  //   } else {
  //     print('Failed to create data: ${response.statusCode}');
  //   }
  // }
}