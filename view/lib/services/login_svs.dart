import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login_SVS{
  String email = '';
  String password = '';

  Login_SVS({required this.email, required this.password});

  Future<Map<String, dynamic>> sendData() async {
    final url = Uri.parse('http://192.168.68.105:8080/user/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': this.email, 'password': this.password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          // Store the JWT token
          await _storeToken(responseData['access_token']);

          return {
            'success': true,
            'message': 'Login successful',
            'token': responseData['access_token'],
          };
        } else {
          return {
            'success': false,
            'message': 'Login failed',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }


  // Utility function to get the stored token
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

}