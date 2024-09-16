import 'dart:ui';

import 'package:flutter/material.dart';

class UI_TextStyle{

  static TextStyle CL_TextStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );

  static TextStyle Title_TextStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(56, 107, 79, 1)
  );

  static TextStyle AccountTitle_TextStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 3
  );

  static TextStyle AccountContext_TextStyle = TextStyle(
    fontSize: 20.0,
    letterSpacing: 2
  );
  
  static TextStyle Collection_TextStyle = TextStyle(
    fontSize: 20.0,
  );
}
