import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/Sour_Record.dart';
import 'package:view/models/User.dart';

class Sour_Record_SVS {
  List<SourRecord> SR = [];
  Sour_Record_SVS({required this.SR});

  //獲取所有紀錄
  Future<void> getAllSR() async {
    final url = Uri.parse('http://192.168.0.75:8080/Sour_Record_Controller/get_ALLSR?user_id=20');
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
  Future<void> getSR(id) async {
    final url = Uri.parse('http://192.168.0.75:8080/Sour_Record_Controller/get?id='+id);
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

  //修改痠痛原因
  Future<void> updateSR(String sour_record_id, String new_value) async {
    final url = Uri.parse('http://192.168.0.75:8080/Sour_Record_Controller/update?id=1');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'sour_record_id': sour_record_id,
        'field_name': "attributs",
        'new_value': new_value
      }),
    );
    if (response.statusCode == 200) {
      print('Data update successfully: ${response.body}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  //刪除痠痛紀錄
  Future<void> deleteSR(String id,) async {
    final url = Uri.parse('http://192.168.0.75:8080/Sour_Record_Controller/delete?id=1');
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
    final url = Uri.parse('http://192.168.0.75:8080/Sour_Record_Controller/create?user_id=20');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': user_id,
        'reason': reason,
        'time':time,
      }),
    );
    if (response.statusCode == 200) {
      print('Data update successfully: ${response.body}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

}
