import 'package:flutter/material.dart';
import 'package:view/widgets/card/collection_Card.dart';
import 'package:view/widgets/button/add_CL_Button.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/services/CollectionList_svs.dart';

import 'package:view/models/CL.dart';
class CollectionListView extends StatefulWidget {
  const CollectionListView({super.key});

  @override
  State<CollectionListView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionListView> {
  List<Map<String, List<String>>> collection_List = [
    {'肩膀': ["放鬆動作", "重訓後舒緩"]},
    {'手腕': ["三招解決", "手腕瑜珈"]}
  ];

  void getCollectionList() async {
    // 從伺服器獲取收藏清單的邏輯
    List<CollectList> CL = [];
    CollectionList_SVS service = new CollectionList_SVS(CL:CL);
    await service.getAllCL();
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    void _updateCL(List<Map<String, List<String>>> newList) {
      setState(() {
        collection_List = newList;
      });
    }
    getCollectionList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(250, 255, 251, 1),
      appBar: AppBar(
        title: Center(
          child: Text(
            "我的收藏",
            style: UI_TextStyle.Title_TextStyle,
          ),
        ),
        backgroundColor: Color.fromRGBO(250, 255, 251, 1),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: collection_List.length,
                    itemBuilder: (context, index) {
                      CollectionListCard collectionListCard = CollectionListCard(context: collection_List[index]);
                      return Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                        child: collectionListCard.getCard(this.context),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            right: MediaQuery.of(context).size.width / 2 - 25,
            child: AddCLButton(CL: collection_List, onUpdateCL: _updateCL).getButton(context),
          ),
        ],
      ),
    );
  }
}
