import 'package:flutter/material.dart';
import 'package:view/constants/button_style.dart';
import 'package:view/constants/route.dart';

class GotoSignupOrLoginButton {
  String message = '';

  GotoSignupOrLoginButton({required this.message});

  TextButton getButton(context, view){
      return TextButton(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.green,
            fontSize: 15,
          ),
        ),
        onPressed: (){
          Navigator.pushReplacementNamed(context, view);
        },
      );
  }
}