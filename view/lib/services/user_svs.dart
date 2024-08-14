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
    final url = Uri.parse('http://192.168.68.104:8080/user/create_user');
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
    final url = Uri.parse('http://192.168.68.104:8080/user/get_user');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('User data get successfully: ${response.body}');
    } else {
      print('Failed to get user: ${response.statusCode}');

    }
  }

  // 獲取個別用戶資料 ok(沒用到)
  Future<User?> get_user_byUserID() async {
    final url = Uri.parse('http://192.168.68.104:8080/user/get_user_byUserID?user_id=21');  //假設user)id抓到20
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('User data get successfully: ${response.body}');
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['response'] != null && data['response'].isNotEmpty) {
        var userData = data['response'][0]; // Get the first user from the response
        return User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          password: userData['password'],
        );
      }
    } else {
      print('Failed to get user: ${response.statusCode}');
    }
  }

  Future<User?> getUserById(String userId) async {
    final url = Uri.parse('http://192.168.68.104:8080/user/get_user_byUserID?user_id=$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['response'] != null && data['response'].isNotEmpty) {
          var userData = data['response'][0];
          return User(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
            password: userData['password'],
          );
        } else {
          print('No user data found or invalid response format');
          return null;
        }
      } else {
        print('Failed to get user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching user data: $e');
      return null;
    }
  }

  // 更新用戶資料(patch) ok
  Future<Map<String, dynamic>> updateUser(String userId, String field, String newValue) async {
    final url = Uri.parse('http://192.168.68.104:8080/user/update_user?user_id=$userId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'field': field, 'new_value': newValue}),
      );

      if (response.statusCode == 200) {
        print('update successfully：${response.body}');
        return {'success': true, 'message': 'success'};
      } else {
        print('update failed：${response.statusCode}');
        return {'success': false, 'message': 'failed：${response.statusCode}'};
      }
    } catch (e) {
      print('更新用戶時發生錯誤：$e');
      return {'success': false, 'message': '更新時發生錯誤：$e'};
    }
  }
  // Future<void> updateUser(String userId, String field, String newValue) async {
  //   final url = Uri.parse('http://192.168.68.104:8080/user/update_user?user_id=$userId');
  //   final response = await http.put(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({field: newValue}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('User updated successfully: ${response.body}');
  //   } else {
  //     print('Failed to update user: ${response.statusCode}');
  //   }
  // }

  // 刪除用戶 (沒有用到)
  Future<void> deleteUser() async {
    final url = Uri.parse('http://192.168.68.104:8080/user/delete_user?user_id=20');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('User deleted successfully: ${response.body}');
    } else {
      print('Failed to delete user: ${response.statusCode}');
    }
  }



}