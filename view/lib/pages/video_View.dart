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

//影片Card
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

  //取得所有收藏
  List<Map<String, dynamic>> getAllCL()async {
    List<Map<String, dynamic>> collection_List = [];
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    List<CollectList> collectList = await service.getAllCL("66435b426b52ed9b072dc0dd");

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
    collection_List = collectList.map((cl) => {
      'id': cl.id,
      'user_id': cl.userId,
      'name': cl.name,
      'collection': cl.collection,
      'count': videoNames.length
    }).toList();

    return collection_List;
  }


  //新增影片到收藏
  void addToCL(){

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
                    onPressed: () async{
                      List<Map<String, dynamic>> _options = getAllCL();
                      await _showCustomModalBottomSheet(context, _options);
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

  void updateCollectionList(clID, type, new_value) async {
    CollectionList_SVS service = CollectionList_SVS(CL: []);
    await service.updateCL(clID, type, new_value);
  }

  Future<void> _showCustomModalBottomSheet(context, List<Map<String, dynamic>> options) async {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context)
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Stack(
                textDirection: TextDirection.rtl,
                children: [
                  Center(
                    child: Text(
                      '收藏分類',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            Divider(height: 1.0),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: FlutterLogo(size: 40.0),
                    title: Text(
                      options[index]['name'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                    subtitle: Text(options[index]['count'].toString() + '部影片'),
                    trailing: Icon(Icons.add_circle_outlined),
                    onTap() async{
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.custom,
                        barrierDismissible: true,
                        confirmBtnText: '確認新增',
                        title: '新增收藏影片,
                        confirmBtnColor: Colors.green,
                        cancelBtnText: '取消',
                        confirmBtnColor: Colors.red,
                        text: '將新增影片至' + options[index]['name'].toString() +'，請確認是否新增?',
                        onConfirmBtnTap: () async {
                          try {
                            // Perform the removal action
                            updateCollectionList(options[index]['id'].toString(), "add_video", video.id);
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
                      );
                    }
                  );
                },
                itemCount: options.length,
              ),
            ),
          ]),
        );
      },
    );
  }
}