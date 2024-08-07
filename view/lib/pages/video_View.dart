import 'package:flutter/material.dart';
import 'package:view/models/Video.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
    getVideo();
  }

  void getVideo(){

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

class VideoCard extends StatelessWidget {

  late Video video;
  VideoCard({required this.video});

  //把yt api抓到的url轉為可以embed的形式
  String getEmbeddedUrl(String url) {
    final videoId = Uri.parse(url).queryParameters['v'];
    return 'https://www.youtube.com/embed/$videoId';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Text(
                    video.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                                style: TextButton.styleFrom(
                                  //backgroundColor: Colors.fromRGBO(95, 178, 132, 0.8),
                                ),
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
