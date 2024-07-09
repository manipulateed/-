import 'package:flutter/material.dart';
import 'package:view/constants/button_style.dart';


class ReturnButton{

  static getButton(context){
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}