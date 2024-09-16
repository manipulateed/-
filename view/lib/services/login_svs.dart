import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:view/constants/config.dart';

class Login_SVS{
  String email = '';
  String password = '';

  Login_SVS({required this.email, required this.password});

  Future<Map<String, dynamic>> sendData() async {
    final url = Uri.parse(Config.baseUrl + '/user/login');
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

  static final key = encrypt.Key.fromUtf8('12345632characterslongpassphrase');
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedToken = encrypter.encrypt(token, iv: iv).base64;
    await prefs.setString('jwt_token', encryptedToken);
  }

  // Utility function to get the stored token
  static Future<String> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedToken = prefs.getString('jwt_token');
    if (encryptedToken != null) {
      return encrypter.decrypt64(encryptedToken, iv: iv);
    }
    return "null";
  }

}