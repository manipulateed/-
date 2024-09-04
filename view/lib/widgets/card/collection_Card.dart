import 'package:flutter/material.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/constants/route.dart';
import 'package:view/services/CollectionList_svs.dart';
import 'package:quickalert/quickalert.dart';

class CollectionListCard extends StatelessWidget {
  final Map<String, dynamic> contextData;
  final VoidCallback onUpdateCollectionList;

  CollectionListCard({
    required this.contextData,
    required this.onUpdateCollectionList,
  });

  void _removeCollectionList(BuildContext context, String clId) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.removeCL(clId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('刪除成功'),
        duration: Duration(seconds: 2),
      ),
    );

    onUpdateCollectionList();
  }

  void _handleDeleteConfirm(BuildContext context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      confirmBtnText: '確認刪除',
      title: '確定要刪除此收藏清單?',
      confirmBtnColor: Colors.green,
      cancelBtnText: '取消',
      text: '請確定是否要刪除此收藏清單?',
      onConfirmBtnTap: () async {
        try {
          Navigator.pop(context);  // Close the confirmation dialog

          _removeCollectionList(context, contextData['id']);

          // Short delay before showing success message
          await Future.delayed(const Duration(milliseconds: 300));

          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "已刪除收藏清單!",
          );
        } catch (e) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "處理過程中出錯了",
          );
        }
      },
      onCancelBtnTap: () {
        Navigator.pop(context);  // Close the confirmation dialog if canceled
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(250, 255, 251, 1),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.collectView,
                arguments: contextData,
              );
              if (result == true) {
                onUpdateCollectionList();
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
                      contextData['name'],
                      style: UI_TextStyle.CL_TextStyle,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () => _handleDeleteConfirm(context),
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
            itemCount: contextData['collection'].length > 3 ? 3 : contextData['collection'].length,
            itemBuilder: (context, index) {
              List<String> items = List<String>.from(contextData['collection']);
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Text(
                            items[index],
                            style: UI_TextStyle.Collection_TextStyle,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
