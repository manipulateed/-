import 'package:http/http.dart' as http;
import 'dart:convert';

class Login_SVS{
  String email = '';
  String password = '';

  Login_SVS({required this.email, required this.password});

  Future<void> sendData() async {
    final url = Uri.parse('http://192.168.0.133:8080/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': this.email}),
    );

    if (response.statusCode == 200) {
      print('Data sent successfully: ${response.body}');
    } else {
      print('Failed to send data: ${response.statusCode}');
    }
  }
}