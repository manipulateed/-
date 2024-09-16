import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/User.dart';
import 'package:view/services/login_svs.dart';
import 'package:view/constants/config.dart';

class User_SVS {
  final String baseUrl = Config.baseUrl;


  Future<User?> getUserById() async {
    String token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('$baseUrl/user/get_user_byUserID');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('回應狀態碼：${response.statusCode}');
      print('回應內容：${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['response'] != null && data['response'].isNotEmpty) {
          var userData = data['response'][0];
          return User(
            id: userData['id']?.toString() ?? '',
            name: userData['name']?.toString() ?? '',
            email: userData['email']?.toString() ?? '',
            password: userData['password']?.toString() ?? '',
            icon: userData['icon']?.toString()?? ''
          );
        } else {
          print('No user data found or invalid response format');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized: Token may be invalid or expired');
        // 這裡可以添加重新登錄的邏輯
        return null;
      } else {
        print('Failed to get user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching user data: $e');
      return null;
    }
  }

  Future<String?> getUserIdByToken(String token) async {
    String token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('$baseUrl/user/get_user_byUserID');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('回應狀態碼token：${response.statusCode}');
      print('回應內容token：${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['response'] != null && data['response'].isNotEmpty) {
          var userData = data['response'][0];
          final user_id = userData['id'].toString();
          print('userId :$user_id');
          return user_id;
        } else {
          print('No user data found or invalid response format');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized: Token may be invalid or expired');
        // 這裡可以添加重新登錄的邏輯
        return null;
      } else {
        print('Failed to get user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching user data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUser(String field, String newValue) async {
    String token =  await Login_SVS.getStoredToken();
    final url = Uri.parse('$baseUrl/user/update_user');
    try {
          final response = await http.put(
            url,
            headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
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

}