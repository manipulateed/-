import 'dart:convert';

class User {
  String name;
  String email;
  String password;
  String? id;
  String? icon;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.id,
    this.icon,
  });

  String getUserData() {
    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password,
      "icon": icon,
    };
    return jsonEncode(userData);
  }
}