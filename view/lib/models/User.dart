import 'dart:convert';

class User {
  String name;
  String email;
  String password;
  String? id;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.id,
  });

  String getUserData() {
    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password,
    };
    return jsonEncode(userData);
  }
}