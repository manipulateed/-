import 'package:flutter/material.dart';
import 'dart:convert';  // 用於JSON解析
import 'package:http/http.dart' as http;
import 'package:view/services/CollectionList_svs.dart';
import 'package:view/models/CL.dart';

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

  @override
  Widget build(BuildContext context) {
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
                        // 編輯按鈕動作
                      },
                      iconSize: 40,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        // 新增按鈕動作
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
