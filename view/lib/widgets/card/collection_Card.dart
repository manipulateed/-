import 'package:flutter/material.dart';
import 'package:view/constants/text_style.dart';
class CollectionListCard{

  String name = "";

  CollectionListCard({required this.name});

  Card getCard(){
    return Card(
      color: Colors.green[100],
      child: ListTile(
        onTap: () {

        },
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0, 15.0),
          child: Text(
            name,
            style: UI_TextStyle.CL_TextStyle,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 40.0,
        ),
      ),
    );
  }
}
