import 'package:flutter/material.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/constants/route.dart';

class CollectionListCard {
  Map<String, List<String>> context = {};

  CollectionListCard({required this.context});

  Card getCard(context) {
    return Card(
      color: Color.fromRGBO(250, 255, 251, 1),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            // border color
            color: Colors.grey.shade400,
            // border thickness
            width: 2,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.collectView);
            },
            leading: Icon(
              Icons.elderly,
              size: 40,
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
              child: Text(
                this.context.keys.toList().first,
                style: UI_TextStyle.CL_TextStyle,
              ),
            ),
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 15,
            endIndent: 15,
            color: Colors.grey,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: this.context.values.first.length,
            itemBuilder: (context, index) {
              String key = this.context.keys.toList().first;
              List<String> items = this.context[key]!;

              if (items.length > index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      color: Color.fromRGBO(233, 245, 239, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Text(
                            items[index],
                            style: UI_TextStyle.Collection_TextStyle,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                              Icons.restore_from_trash),
                              color: Color.fromRGBO(56, 107, 79 , 1),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(); // 確保不返回null
              }
            },
          ),
        ],
      ),
    );
  }
}
