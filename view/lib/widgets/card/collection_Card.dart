import 'package:flutter/material.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/constants/route.dart';
import 'dart:convert';
import 'package:view/services/CollectionList_svs.dart';

class CollectionListCard {
  Map<String, dynamic> context = {};
  dynamic Function() onUpdateCL;
  CollectionListCard({required this.context, required this.onUpdateCL});

  void _handlePressed() {
    onUpdateCL();
  }

  void removeCollectionList(String cl_id) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.removeCL(cl_id);
    // 顯示刪除成功的通知
    ScaffoldMessenger.of(context["name"]).showSnackBar(
      SnackBar(
        content: Text('刪除成功'),
        duration: Duration(seconds: 2),
      ),
    );
    getCard(context);
  }

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
            onTap: () async{
              final result = await Navigator.pushNamed(
                context,
                Routes.collectView,
                arguments: this.context,
              );
              if (result == true) {
                _handlePressed();
              }
            },
            leading: Icon(
              Icons.elderly,
              size: 40,
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      this.context['name'],
                      style: UI_TextStyle.CL_TextStyle,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () {
                      removeCollectionList(this.context['id']);
                    },
                  ),
                ],
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
              // String key = this.context.keys.toList().first;
              // List<String> items = this.context[key]!;
              String key = "collection";// 先嘗試解析為 List<dynamic>
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
                        Expanded(  // 使用 Expanded 包裝 Text 以確保它占據最大空間
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              items[index],
                              style: UI_TextStyle.Collection_TextStyle,
                              softWrap: true, // 啟用自動換行
                              overflow: TextOverflow.ellipsis, // 如果超出範圍則使用省略號
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.restore_from_trash),
                        //   color: Color.fromRGBO(56, 107, 79 , 1),
                        // ),
                      ],
                    ),
                  ),
                );
              }else {
                return Container(); // 確保不返回null
              }
            },
          ),
        ],
      ),
    );
  }
}
