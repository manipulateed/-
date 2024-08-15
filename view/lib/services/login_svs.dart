import 'package:http/http.dart' as http;
import 'dart:convert';

class Login_SVS{
  String email = '';
  String password = '';

  Login_SVS({required this.email, required this.password});

  // Future<void> sendData() async {
  //   final url = Uri.parse('http://192.168.1.115:8080/login');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': this.email, 'password': this.password}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Data sent successfully: ${response.body}');
  //   } else {
  //     print('Failed to send data: ${response.statusCode}');
  //   }
  // }

  Future<Map<String, dynamic>> sendData() async {
    final url = Uri.parse('http://192.168.68.104:8080/user/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': this.email, 'password': this.password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return {
            'success': true,
            'message': 'Login successful',
            'userData': responseData['received'],
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
          'message': 'Failed to login: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error occurred: $e',
      };
    }
  }


}