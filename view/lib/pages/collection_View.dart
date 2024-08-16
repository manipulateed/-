import 'package:flutter/material.dart';
import 'dart:convert';  // 用於JSON解析
import 'package:http/http.dart' as http;
import 'package:view/services/CollectionList_svs.dart';
import 'package:view/models/CL.dart';
import 'package:view/models/Video.dart';
import 'package:view/pages/video_View.dart';
import 'package:quickalert/quickalert.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  String userID = '';
  String clID = '';
  String clName = '';
  List<String> collections = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> collectionItem = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userID = collectionItem['user_id'];
    clID = collectionItem['id'];

    getOneCL();
  }

  void _editCLName() async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: '確認',
      title: '編輯收藏清單名稱',
      confirmBtnColor: Colors.green,
      widget: TextFormField(
        initialValue: clName,
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: '請輸入新的名稱',
        ),
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          clName = value;
        },
      ),
      onConfirmBtnTap: () async {
        if (clName.length < 5) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: '請輸入有效名稱（至少 5 個字）',
          );
          return;
        }
        updateCollectionList("name",clName);
        // 更新資料庫中的名稱

        Navigator.pop(context);  // 關閉編輯對話框
        await Future.delayed(const Duration(milliseconds: 300));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "收藏清單名稱已更新為 '$clName'!",
        );
      },
    );
  }

  Future<void> getOneCL() async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);

    try {
      CollectList collectList = await service.getCL(userID, clID);

      setState(() {
        clName = collectList.name;
        collections = collectList.collection;
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  void updateCollectionList(type, new_value) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.updateCL(clID, type, new_value);
  }

  @override
  Widget build(BuildContext context) {
    updateCollectionList("name","clName");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: AppBar(
          title: const Text(""),
          flexibleSpace: Center(
            child: Text(
              clName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context); // 返回上一頁
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clName,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '運動傷害\n${collections.length}部影片',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        _editCLName();
                        // 編輯按鈕動作
                      },
                      iconSize: 40,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: collections.map((video) {
                  return VideoEntry(
                    title: video,
                    videoLength: '未知時間', // 如果需要，可以改為實際的影片長度
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoEntry extends StatelessWidget {
  final String title;
  final String videoLength;

  const VideoEntry({super.key, required this.title, required this.videoLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Image.network(imageUrl),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: Text(
                      videoLength,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
