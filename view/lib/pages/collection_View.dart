import 'package:flutter/material.dart';
import 'dart:convert';  // 用於JSON解析
import 'package:http/http.dart' as http;
import 'package:view/services/CollectionList_svs.dart';
import 'package:view/models/CL.dart';
import 'package:view/models/Video.dart';
import 'package:view/pages/video_View.dart';
import 'package:quickalert/quickalert.dart';
import 'package:view/services/Video_svs.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late List<Video> videos = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> collectionItem = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userID = collectionItem['user_id'];
    clID = collectionItem['id'];

    getOneCL();
  }

  void _fetchVideos() async {
    List<Video> clvideos = [];
    for (var videoId in collections) {
      Video video = Video(id: videoId);
      Video_SVS videoService = Video_SVS(videos: video);
      await videoService.getVideoById(videoId);
      clvideos.add(videoService.videos);
    }
    setState(() {
      videos =  clvideos;
    });
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
    _fetchVideos();
  }

  void updateCollectionList(type, new_value) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.updateCL(clID, type, new_value);
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
              Navigator.pop(context, true); // 返回上一頁
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
              child:  ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return VideoCardInCL(video: videos[index], clID: clID);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(child: CircularProgressIndicator()); // 資料加載中顯示的進度條
// } else if (snapshot.hasError) {
// return Center(child: Text("加載影片時出錯了")); // 錯誤處理
// } else {
// List<Video> clvideos = snapshot.data as List<Video>;
// return ListView.builder(
// itemCount: clvideos.length,
// itemBuilder: (context, index) {
// return VideoCardInCL(video: clvideos[index], clID: clID);
// },
// );
// }
// },
// class VideoEntry extends StatelessWidget {
//   final String title;
//   final String videoLength;
//
//   const VideoEntry({super.key, required this.title, required this.videoLength});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 // Image.network(imageUrl),
//                 Positioned(
//                   bottom: 8.0,
//                   right: 8.0,
//                   child: Container(
//                     color: Colors.black.withOpacity(0.7),
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
//                     child: Text(
//                       videoLength,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 style: const TextStyle(fontSize: 16.0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class VideoCardInCL extends StatefulWidget {
  final Video video;
  final String clID; // 添加 cl_id 作為參數

  VideoCardInCL({required this.video, required this.clID}); // 在構造函數中傳入 cl_id

  @override
  _VideoCardInCLState createState() => _VideoCardInCLState();
}

class _VideoCardInCLState extends State<VideoCardInCL> {
  late Video video;
  late String clID;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    clID = widget.clID;
  }

  void updateCollectionList(type, new_value) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.updateCL(clID, type, new_value);
  }

  Future<void> _removeCLVideo() async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: '移除影片',
      text: '你確定要從收藏清單中移除這部影片嗎？',
      confirmBtnText: '確認',
      cancelBtnText: '取消',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        if (!mounted) return;  // 确保当前 widget 仍然挂载
        try {
          // Perform the removal action
          updateCollectionList("remove_video", video.id);
          print("updateCollectionList");

          // Close the confirmation dialog
          Navigator.pop(context);
          print("Close the confirmation dialog");
          // Short delay before showing success message
          await Future.delayed(const Duration(milliseconds: 300));

          if (mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "影片已從收藏清單中移除!",
            );
            print("影片已從收藏清單中移除");
          }
        } catch (e) {
          // Handle any errors that occur during the removal
          if (mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "處理過程中出錯了",
            );
            print("處理過程中出錯了");
          }
        }
      },
      onCancelBtnTap: () {
        if (mounted) {
          Navigator.pop(context);  // Close the confirmation dialog if canceled
        }
      },
    );
  }

  // 把 YouTube API 抓到的 URL 轉為可以嵌入的形式
  String getEmbeddedUrl(String url) {
    final videoId = Uri.parse(url).queryParameters['v'];
    return 'https://www.youtube.com/embed/$videoId';
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              child: WebView(
                initialUrl: getEmbeddedUrl(video.url!),
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      video.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _removeCLVideo();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}
