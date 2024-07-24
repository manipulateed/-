import 'dart:convert';

class User {
  String name;
  String email;
  String birth;
  String password;
  String sex;
  String? id;

  User({
    required this.name,
    required this.email,
    required this.birth,
    required this.password,
    required this.sex,
    this.id,
  });

  String getUserData() {
    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password,
      "birthday": birth,
      "sex": sex
    };
    return jsonEncode(userData);
  }
}