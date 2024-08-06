import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/CL.dart';
import 'package:view/models/User.dart';
import 'package:view/models/Video.dart';

class CollectionList_SVS{

  List<CollectList> CL = [];
  CollectionList_SVS({required this.CL});

  late User user;

  // Future<void> getAllCL() async {
  //   final url = Uri.parse('http://192.168.1.113:8080/Collect_List_Controller/get_ALLCL?user_id=66435b426b52ed9b072dc0dd');
  //   final response = await http.get(
  //     url
  //   );

  //   if (response.statusCode == 200) {
  //     final content = jsonDecode(response.body);
  //     print('Data get successfully: ${content["response"]}');
  //   } else {
  //     print('Failed to get data: ${response.statusCode}');
  //   }
  // }

   Future<List<CollectList>> getAllCL(String userId) async {
    final url = Uri.parse('http://192.168.1.105:8080/Collect_List_Controller/get_ALLCL?user_id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      List<dynamic> responseList = content["response"];
      
      // 印出每一項資料以便調試
      for (var item in responseList) {
        print('Item: $item');
      }

      List<CollectList> collectList = responseList.map((item) {
        try {
          return CollectList.fromJson(item as String);
        } catch (e) {
          print('Error parsing item: $item');
          throw e;
        }
      }).toList();

      return collectList;
    } else {
      print('Failed to get data: ${response.statusCode}');
      return [];
    }
}



  Future<void> getCL() async {
    final url = Uri.parse('http://192.168.1.105:8080/Collect_List_Controller/get_CL?user_id=20?name=name');
    final response = await http.get(
        url
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      print('Data get successfully: ${content["response"]}');
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  Future<void> updateCL(type, new_value) async {
    final url = Uri.parse('http://192.168.1.105:8080/Collect_List_Controller/update_CL?cl_id=66a767bf942cd90c930db069&type=name&new_value=UpdateName');

    final response = await http.put(
        url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'cl_id': "66a767bf942cd90c930db069",
          'type': type,
          'new_valur': new_value
        }),
    );

    if (response.statusCode == 200) {
      print('Data update successfully: ${response.body}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  // Future<void> createCL() async {
  //   final url = Uri.parse('http://192.168.1.105:8080/Collect_List_Controller/create_CL?user_id=66435b426b52ed9b072dc0dd&name=NewCLName');
  //
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({
  //       'user_id': "2066435b426b52ed9b072dc0dd",
  //       'name': "NewCLName",
  //     }),
  //   );
  //
  //
  //   if (response.statusCode == 200) {
  //     print('Data create successfully: ${response.body}');
  //   } else {
  //     print('Failed to create data: ${response.statusCode}');
  //   }
  // }
  Future<bool> createCL(String userId, String name) async {
    final url = Uri.parse('http://192.168.1.105:8080/Collect_List_Controller/create_CL');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': userId,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      return content['success'];
    } else {
      print('創建收藏清單失敗，狀態碼：${response.statusCode}');
      print('錯誤訊息：${response.body}');
      return false;
    }
  }


  Future<void> removeCL() async {
    final url = Uri.parse('http://192.168.1.105:8080/Collect_List_Controller/remove_CL?cl_id=6684e10320ee6b4cf0b2dfaf');

    final response = await http.delete(
        url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'cl_id': "6684e10320ee6b4cf0b2dfaf",
        }),
    );

    if (response.statusCode == 200) {
      print('Data delete successfully: ${response.body}');
    } else {
      print('Failed to delete data: ${response.statusCode}');
    }
  }

}