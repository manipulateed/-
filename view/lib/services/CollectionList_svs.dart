import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/CL.dart';
import 'package:view/models/User.dart';
import 'package:view/models/Video.dart';

class CollectionList_SVS{

  List<CollectList> CL = [];
  CollectionList_SVS({required this.CL});

  late User user;

  Future<void> getAllCL() async {
    final url = Uri.parse('http://172.20.10.3:8080/Collect_List_Controller/get_ALLCL?user_id=20');
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

  Future<void> getCL() async {
    final url = Uri.parse('http://172.20.10.3:8080/Collect_List_Controller/get_CL?user_id=20?name=name');
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
    final url = Uri.parse('http://172.20.10.3:8080/Collect_List_Controller/update_CL?user_id=20');

    final response = await http.put(
        url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'cl_id': CL[0].id,
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

  Future<void> createCL() async {
    final url = Uri.parse('http://172.20.10.3:8080/Collect_List_Controller/create_CL');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': user.id,
        'name': CL[0].name,
      }),
    );

    if (response.statusCode == 200) {
      print('Data create successfully: ${response.body}');
    } else {
      print('Failed to create data: ${response.statusCode}');
    }
  }

}