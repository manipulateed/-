import 'package:flutter/material.dart';
import 'package:view/widgets/card/collection_Card.dart';
import 'package:view/widgets/button/add_CL_Button.dart';
import 'package:view/constants/text_style.dart';
import 'package:view/services/CollectionList_svs.dart';
import 'package:view/services/Video_svs.dart';
import 'package:view/pages/Collection_View.dart';
import 'package:view/constants/route.dart';

import 'package:view/models/CL.dart';
import 'package:view/models/Video.dart';

class CollectionListView extends StatefulWidget {
  const CollectionListView({super.key});

  @override
  State<CollectionListView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionListView> {
  List<Map<String, dynamic>> collection_List = [];

  // {'肩膀': ["放鬆動作", "重訓後舒緩"]},
  // {'手腕': ["三招解決", "手腕瑜珈"]}
  
  @override
  void initState() {
    super.initState();
    getCollectionList();
  }

  void getCollectionList() async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    List<CollectList> collectList = await service.getAllCL("66435c496b52ed9b072dc0e4");

    for (var cl in collectList) {
      print('ID: ${cl.id}, User ID: ${cl.userId}, Name: ${cl.name}, Collection: ${cl.collection}');

      // 建立一個新的 list 來存放 Video_Name
      List<String> videoNames = [];

      // 創建一個 Future 列表來等待所有的 video 請求
      List<Future<void>> futures = [];

      for (var videoId in cl.collection) {
        futures.add(
          Future<void>(() async {
            Video video = Video(id: videoId);
            Video_SVS videoService = Video_SVS(videos: video);

            // 使用 Video_SVS 來獲取 video 的名稱
            await videoService.getVideoById(videoId);
            String videoName = videoService.videos.name;
            print("videoName:"+videoName);

            // 將 videoName 添加到 videoNames 列表中
            videoNames.add(videoName);
          }),
        );
      }

      // 等待所有的影片請求完成後再進行更新
      await Future.wait(futures);

      // 將 cl.collection 更新為 videoNames
      cl.collection = videoNames;
    }

    // 在所有的影片名稱都更新完後再進行狀態刷新
    setState(() {
      collection_List = collectList.map((cl) => {
        'id': cl.id,
        'user_id': cl.userId,
        'name': cl.name,
        'collection': cl.collection,
      }).toList();
    });
  }



  void createCollectionList(String newName) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    bool success = await service.createCL("66435c496b52ed9b072dc0e4",newName);

    if (success) {
      getCollectionList();
    } else {
      print('創建收藏清單失敗');
    }
  }

  // void updateCollectionList(type, new_value) async {
  //   List<CollectList> CL = [];
  //   CollectionList_SVS service = CollectionList_SVS(CL: CL);
  //   await service.updateCL(type, new_value);
  // }

  void removeCollectionList(String cl_id) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.removeCL(cl_id);
    getCollectionList();
  }

  @override
  Widget build(BuildContext context) {
    // removeCollectionList("66860a6a6a4b4baac976185c");
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
                      CollectionListCard collectionListCard = CollectionListCard(context: collection_List[index], onUpdateCL: getCollectionList);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: collectionListCard.getCard(context)),
                            // IconButton(
                            //   icon: Icon(Icons.delete, color: Colors.black),
                            //   onPressed: () {
                            //     removeCollectionList(collection_List[index]['id']);
                            //   },
                            // ),
                          ],
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
