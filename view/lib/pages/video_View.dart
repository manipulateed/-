import 'package:flutter/material.dart';
import 'package:view/models/Video.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:view/services/Video_svs.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {

  final List<VideoCard> videoCards = [];
  late List<Video> videos = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    videos = ModalRoute.of(context)!.settings.arguments as List<Video>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '推薦影片',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(95, 178, 132, 0.8),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 75,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(95, 178, 132, 0.8),
              ),
              alignment: Alignment.center,
              child: Text(
                '<',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Indie Flower',
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: videos.length, // videoCards 是包含 VideoCard 數據的列表
          itemBuilder: (context, index) {
            VideoCard videoCard = new VideoCard(video: videos[index]);
          return videoCard; // 這裡可以使用 videoCards[index] 來生成每個 VideoCard
        },
      )
    );
  }
}

class VideoCard extends StatefulWidget {
  final Video video;

  VideoCard({required this.video});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {

  late Video video;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    getVideo();
  }

  void getVideo() async {
    Video_SVS service = Video_SVS(videos: video);
    await service.getVideoById(video.id);
    setState(() {
      video = service.videos;
      isLoading = false; // 資料加載完成後設置為 false
    });
  }
  //把yt api抓到的url轉為可以embed的形式
  String getEmbeddedUrl(String url) {
    final videoId = Uri.parse(url).queryParameters['v'];
    return 'https://www.youtube.com/embed/$videoId';
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator()) // 資料加載中
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
                      softWrap: true, // 啟用換行
                      maxLines: 2,   // 設定最大行數（例如2行）
                      overflow: TextOverflow.ellipsis, // 如果內容超出，則在最後一行顯示省略號
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.star_border, color: Color.fromRGBO(95, 178, 132, 0.8)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('加入收藏清單'),
                            content: Text('將影片加入到哪個收藏清單？'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('清單1'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // 加入到清單1的操作
                                },
                              ),
                              TextButton(
                                child: Text('清單2'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // 加入到清單2的操作
                                },
                              ),
                            ],
                          );
                        },
                      );
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

// class VideoCardInCL extends StatefulWidget {
//   final Video video;
//   final Function onDelete;
//
//   VideoCardInCL({required this.video, required this.onDelete});
//
//   @override
//   _VideoCardInCLState createState() => _VideoCardInCLState();
// }

// class _VideoCardInCLState extends State<VideoCardInCL> {
//   late Video video;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     video = widget.video;
//     getVideo();
//   }
//
//   void _removeCLVideo(String videoID) async {
//     QuickAlert.show(
//       context: context,
//       type: QuickAlertType.confirm,
//       title: '移除影片',
//       text: '你確定要從收藏清單中移除這部影片嗎？',
//       confirmBtnText: '確認',
//       cancelBtnText: '取消',
//       confirmBtnColor: Colors.red,
//       onConfirmBtnTap: () async {
//         updateCollectionList("remove_video", videoID);
//         // 更新資料庫，將影片從收藏清單中移除
//
//         Navigator.pop(context); // 關閉確認對話框
//         await Future.delayed(const Duration(milliseconds: 300));
//         await QuickAlert.show(
//           context: context,
//           type: QuickAlertType.success,
//           text: "影片已從收藏清單中移除!",
//         );
//       },
//     );
//   }
//
//   void getVideo() async {
//     Video_SVS service = Video_SVS(videos: video);
//     await service.getVideoById(video.id);
//     setState(() {
//       video = service.videos;
//       isLoading = false;
//     });
//   }
//
//   // 把 YouTube API 抓到的 URL 轉為可以嵌入的形式
//   String getEmbeddedUrl(String url) {
//     final videoId = Uri.parse(url).queryParameters['v'];
//     return 'https://www.youtube.com/embed/$videoId';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? Center(child: CircularProgressIndicator())
//         : Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 200.0,
//               child: WebView(
//                 initialUrl: getEmbeddedUrl(video.url!),
//                 javascriptMode: JavascriptMode.unrestricted,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       video.name,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                       softWrap: true,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       _removeCLVideo(video.id);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 4.0),
//           ],
//         ),
//       ),
//     );
//   }
// }