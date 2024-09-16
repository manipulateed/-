import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:view/models/User.dart';
import 'package:view/constants/config.dart';

class Signup_SVS{
  User user;
  Signup_SVS({required this.user});

  Future<Map<String, dynamic>> createUser() async {
    final url = Uri.parse(Config.baseUrl+'/user/create_user');
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
}