import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Sour_Record.dart';
import 'package:view/models/User.dart';

class Sour_Record_SVS {
  List<SourRecord> SR = [];
  Sour_Record_SVS({required this.SR});
  final String baseUrl = 'http://172.20.10.3:8080';

  //獲取所有紀錄
  Future<void> getAllSR(user_id) async {
    final url = Uri.parse('${baseUrl}/Sour_Record_Controller/get_ALLSR?user_id='+user_id);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      print('Data get successfully: ${content["response"]}');
      List<dynamic> responseData = content['response'];
      SR = responseData.map((data) => SourRecord.fromJson(data)).toList();
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  //取得單一痠痛紀錄

  // Future<void> getSR(id) async {
  //   final url = Uri.parse('http://192.168.0.75:8080/Sour_Record_Controller/get?id='+id);
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     final content = jsonDecode(response.body);
  //     print('Data get successfully: ${content["response"]}');
  //     List<dynamic> responseData = content['response'];
  //     SR = responseData.map((data) => SourRecord.fromJson(data)).toList();
  //   } else {
  //     print('Failed to get data: ${response.statusCode}');
  //   }
  // }

  Future<void> getSR(id) async {
    final url = Uri.parse('${baseUrl}/Sour_Record_Controller/get?id=' + id);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      print('Data received: $content');

      if (content is Map<String, dynamic> && content.containsKey('response')) {
        var responseData = content['response'];

        // Check if responseData is a List or Map
        if (responseData is List) {
          // If responseData is a List
          SR = responseData.map((data) => SourRecord.fromJson(data)).toList();
        } else if (responseData is Map) {
          if (responseData is Map<String, dynamic>) {
            SR = [SourRecord.fromJson(responseData)];
          } else {
            print('responseData is not a Map: $responseData');
          }
        }
      }
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }



  //修改痠痛原因
  Future<void> updateSR(String sour_record_id, String new_value) async {
    final url = Uri.parse('${baseUrl}/Sour_Record_Controller/update?id='+sour_record_id);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'sour_record_id': sour_record_id,
        'field_name': "Reason",
        'new_value': new_value
      }),
    );
    if (response.statusCode == 200) {
      print('Data update successfully: ${jsonDecode(response.body)['message']}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  //刪除痠痛紀錄
  Future<void> deleteSR(String id) async {
    final url = Uri.parse('${baseUrl}/Sour_Record_Controller/delete?id='+id);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'sour_record_id': id,
      }),
    );
    if (response.statusCode == 200) {
      print('Data update successfully: ${response.body}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  //新增痠痛
  Future<void> createSR(String user_id, String reason, String time) async {
    final url = Uri.parse('${baseUrl}/Sour_Record_Controller/create?user_id='+user_id);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': user_id,
        'reason': reason,
        'time':time,
        'videos':[]
      }),
    );
    if (response.statusCode == 200) {
      print('Data update successfully: ${response.body}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

}
