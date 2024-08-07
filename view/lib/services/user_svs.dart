import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/User.dart';

class User_SVS {
  User user;
  User_SVS({required this.user});

  // 創建用戶 ok
  // Future<void> createUser() async {
  //   final url = Uri.parse('http://192.168.68.101:8080/user/create_user');
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({
  //       'name': user.name,
  //       'email': user.email,
  //       'password': user.password,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('User created successfully: ${response.body}');
  //   } else {
  //     print('Failed to create user: ${response.statusCode}');
  //   }
  // }

  Future<Map<String, dynamic>> createUser() async {
    final url = Uri.parse('http://192.168.1.115:8080/user/create_user');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': user.password,
        }),
      );

      final responseData = jsonDecode(response.body);
      print('Server response: $responseData');

      if (response.statusCode == 200) {
        if (responseData['response']['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'User created successfully',
          };
        } else {
          return {
            'success': false,
            'message': responseData['response']['message'] ?? 'Failed to create user',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to create user. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error creating user: $e');
      return {
        'success': false,
        'message': 'Error creating user: $e',
      };
    }
  }

  // 獲取用戶資料 (沒有用到)
  Future<void> get_user() async {
    final url = Uri.parse('http://192.168.1.115:8080/user/get_user');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('User data get successfully: ${response.body}');
    } else {
      print('Failed to get user: ${response.statusCode}');

    }
  }

  // 獲取個別用戶資料 ok
  Future<void> get_user_byUserID() async {
    final url = Uri.parse('http://192.168.1.115:8080/user/get_user_byUserID?user_id=20');  //假設user)id抓到20
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('User data get successfully: ${response.body}');
    } else {
      print('Failed to get user: ${response.statusCode}');
    }
  }



  // 更新用戶資料(patch) ok
  Future<void> updateUser(String field, String newValue) async {
    final url = Uri.parse('http://192.168.1.115:8080/user/update_user?user_id=20');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({field: newValue}),
    );

    if (response.statusCode == 200) {
      print('User updated successfully: ${response.body}');
    } else {
      print('Failed to update user: ${response.statusCode}');
    }
  }


  // 刪除用戶 (沒有用到)
  Future<void> deleteUser() async {
    final url = Uri.parse('http://192.168.1.115:8080/user/delete_user?user_id=20');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('User deleted successfully: ${response.body}');
    } else {
      print('Failed to delete user: ${response.statusCode}');
    }
  }



}