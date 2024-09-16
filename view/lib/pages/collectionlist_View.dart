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
    List<CollectList> collectList = await service.getAllCL();

    for (var cl in collectList) {
      //print('ID: ${cl.id}, User ID: ${cl.userId}, Name: ${cl.name}, Collection: ${cl.collection}');

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
            //print("videoName:"+videoName);

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
    bool success = await service.createCL(newName);

    if (success) {
      getCollectionList();
    } else {
      print('創建收藏清單失敗');
    }
  }

  void removeCollectionList(String cl_id) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.removeCL(cl_id);
    getCollectionList();
  }

  @override
  Widget build(BuildContext context) {
    void _updateCL(String addname) {
      createCollectionList(addname);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            '我的收藏',
            style: TextStyle(
              color: Color.fromRGBO(56, 107, 79, 1),
              fontWeight: FontWeight.bold,
              letterSpacing: 3
            )
        ),
        backgroundColor: Colors.green[100],
        elevation: 3,
        centerTitle: true,
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
                      CollectionListCard collectionListCard = CollectionListCard(contextData: collection_List[index], onUpdateCollectionList: getCollectionList);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: collectionListCard),
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
