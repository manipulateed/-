import 'package:flutter/material.dart';
import 'package:view/widgets/card/collection_Card.dart';
import 'package:view/widgets/button/add_CL_Button.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/services/CollectionList_svs.dart';
import 'package:view/pages/Collection_View.dart';

import 'package:view/models/CL.dart';

class CollectionListView extends StatefulWidget {
  const CollectionListView({super.key});

  @override
  State<CollectionListView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionListView> {
  List<Map<String, List<String>>> collection_List = [];

  // {'肩膀': ["放鬆動作", "重訓後舒緩"]},
  // {'手腕': ["三招解決", "手腕瑜珈"]}
  
  @override
  void initState() {
    super.initState();
    getCollectionList();
  }

  void getCollectionList() async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    List<CollectList> collectList = await service.getAllCL("66435b426b52ed9b072dc0dd");
    setState(() {
      collection_List = collectList.map((cl) => {
        cl.name: cl.collection
      }).toList();
    });
  }

  void createCollectionList(String newName) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    bool success = await service.createCL("66435b426b52ed9b072dc0dd",newName);

    if (success) {
      getCollectionList();
    } else {
      print('創建收藏清單失敗');
    }
  }

  void updateCollectionList(type, new_value) async {
    List<CollectList> CL = [];
    CollectionList_SVS service = CollectionList_SVS(CL: CL);
    await service.updateCL(type, new_value);
  }

  void removeCollectionList(String cl_id) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.removeCL(cl_id);
    getCollectionList();
  }

  @override
  Widget build(BuildContext context) {
    // void _updateCL(List<Map<String, List<String>>> newList) {
    //   setState(() {
    //     collection_List = newList;
    //   });
    // }
    void _updateCL(String addname) {
      createCollectionList(addname);
    }

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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollectionView(
                                userID: "66435b426b52ed9b072dc0dd",
                                clID: collection_List[index].keys.first,
                              ),
                            ),
                          );
                        },
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              collectionListCard.getCard(context),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.black),
                                onPressed: () {
                                  removeCollectionList(collection_List[index].keys.first);
                                },
                              ),
                            ],
                          ),
                        ),
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
