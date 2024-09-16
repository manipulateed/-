import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/CL.dart';
import 'package:view/models/User.dart';
import 'package:view/models/Video.dart';
import 'package:view/services/login_svs.dart';
import 'package:view/constants/config.dart';

class CollectionList_SVS{

  List<CollectList> CL = [];
  CollectionList_SVS({required this.CL});
  final String baseUrl = Config.baseUrl;
  late User user;

  Future<List<CollectList>> getAllCL() async {
    String token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('${baseUrl}/Collect_List_Controller/get_ALLCL');
    final response = await http.get(
      url,
      headers:{'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      List<dynamic> responseList = content["response"];

      // 印出每一項資料以便調試
      // for (var item in responseList) {
      //   print('Item: $item');
      // }

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

  Future<CollectList> getCL(String clId) async {
    String token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('${baseUrl}/Collect_List_Controller/get_CL?ClId=$clId');
    final response = await http.get(
        url,
        headers:{'Authorization': 'Bearer $token',
        }
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      print('Data get successfully: ${content["response"]}');
      CollectList collectList = CollectList.fromJson(content["response"]);
      return collectList;
    } else {
      print('Failed to get data: ${response.statusCode}');
      throw Exception('Failed to get data');  // 引發異常以處理請求失敗情況
    }
  }


  Future<void> updateCL(cl_id ,type, new_value) async {
    final url = Uri.parse('${baseUrl}/Collect_List_Controller/update_CL');

    final response = await http.put(
        url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'cl_id': cl_id,
          'type': type,
          'new_value': new_value
        }),
    );

    if (response.statusCode == 200) {
      print('Data update successfully: ${response.body}');
    } else {
      print('Failed to update data: ${response.statusCode}');
    }
  }

  Future<bool> createCL(String name) async {
    String token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('${baseUrl}/Collect_List_Controller/create_CL');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
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


  Future<void> removeCL(String cl_id) async {
    final url = Uri.parse('${baseUrl}/Collect_List_Controller/remove_CL');

    final response = await http.delete(
        url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'cl_id': cl_id,
        }),
    );

    if (response.statusCode == 200) {
      print('Data delete successfully: ${response.body}');
    } else {
      print('Failed to delete data: ${response.statusCode}');
    }
  }
}