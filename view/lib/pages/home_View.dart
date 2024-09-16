import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';
import 'package:view/models/Chat_Record.dart';
import 'package:view/services/chatrecord_svs.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<ChatRecord> chatrecords = [];

  @override
  void initState() {
    super.initState();
    // 在這裡初始化你的聊天紀錄
    get_ChatRecords();
  }

  // Icon data with asset paths and corresponding information
  final List<Map<String, dynamic>> iconData = [
    {
      'asset': 'assets/背.png',
      'title': '背部',
      'description': '上背痛/膏肓痛、不明原因上背痛、上交叉症候群',
      'url': 'https://www.weili-clinic.com/knowledge/category-46/post-147',
    },
    {
      'asset': 'assets/手.png',
      'title': '手部',
      'description': '手麻、媽媽手、板機指、腕隧道症候群、肘隧道症候群、橈神經病變、網球肘、高爾夫球肘、三角纖維軟骨',
      'url': 'https://www.weili-clinic.com/knowledge/category-46/post-147',
    },
    {
      'asset': 'assets/肩膀.png',
      'title': '肩部',
      'description': '肩關節痛、肩膀活動度改善、五十肩、肩夾擠症候群、旋轉肌袖症候群、鈣化性肌腱炎、胸廓出口症候群、肩關節唇撕裂',
      'url': 'https://www.weili-clinic.com/knowledge/category-46/post-147',
    },
    {
      'asset': 'assets/腰.png',
      'title': '腰部',
      'description': '脊椎側彎、腰椎滑脫、脊椎小面關節炎、脊椎狹窄症、下交叉症候群',
      'url': 'https://www.weili-clinic.com/knowledge/category-46/post-147',
    },
    {
      'asset': 'assets/腿.png',
      'title': '腿部',
      'description': '腔室症候群、疲勞性骨折、夾脛症',
      'url': 'https://www.weili-clinic.com/knowledge/category-46/post-147',
    },
    {
      'asset': 'assets/足底.png',
      'title': '足、踝',
      'description': '高足弓、扁平足、足底筋膜炎、足弓痛舒緩、足踝扭傷、副舟狀骨症候群、腳踝積水、跟腱炎、拇指外翻',
      'url': 'https://www.weili-clinic.com/knowledge/category-46/post-147',

    },


  ];


  Future<void> get_ChatRecords() async{
    Chatrecord_SVS service = new Chatrecord_SVS(chatrecords:chatrecords);
    await service.getAllChatRecords();
    setState(() {
      chatrecords = service.chatrecords.reversed.toList();
    });
  }


  Future<void> createChatRecord(ChatRecord chatrecord) async {
    chatrecords.add(chatrecord);
    Chatrecord_SVS service = Chatrecord_SVS(chatrecords: chatrecords);
    await service.createChatRecord();
    await get_ChatRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFE9F5EF),
      body: Column(
        children: [
          // Top section with gradient background image
          Stack(
            children: [
              Image.asset(
                'assets/home_background.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                top: 100,
                child: Text(
                  'byebyesore.',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),

          Spacer(flex: 1),

          // Middle section with icons
          Container(
            padding: EdgeInsets.all(16),
            child: _buildIconWithBackground(),
          ),

          Spacer(flex: 2),

          // New Chat section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () async {
                    String message= "";
                    late ChatRecord chatRecord;
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.custom,
                      barrierDismissible: true,
                      confirmBtnText: '確認新增',
                      title: '新增Chat Room',
                      confirmBtnColor: Colors.green,
                      widget: TextFormField(
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: '請輸入名稱',
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => chatRecord = new ChatRecord(id: "",userId: "", message: [], suggestedVideoIds: [], name: value, timestamp: "", finish: "no"),
                      ),
                      onConfirmBtnTap: () async {
                        if (chatRecord.name.length < 3) {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Please input more than two words.',
                          );
                          return;
                        }
                        if (chatrecords.any((element) => element.name == chatRecord.name)) {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: '請輸入其他名稱!',
                            confirmBtnText: '確認',
                            title: '該名稱已存在!',
                            confirmBtnColor: Colors.green,
                          );
                          return;
                        }
                        Navigator.pop(context);
                        await createChatRecord(chatRecord);
                        await Future.delayed(const Duration(milliseconds: 300));
                        final result = await Navigator.pushNamed(context, Routes.chatView, arguments: chatrecords.first);
                        if (result == true){
                          get_ChatRecords();
                        }
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green[50],
                        child: Icon(Icons.add, color: Color.fromRGBO(56, 107, 79, 1)),
                      ),
                      SizedBox(width: 70),
                      Center(
                        child: Text(
                          '酸通諮詢',
                          style: TextStyle(
                              color: Color.fromRGBO(56, 107, 79, 1),
                              fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer(flex: 1),

          Expanded(
            child: ListView.builder(
              itemCount: chatrecords.length,
              itemBuilder: (context, index) {
                return ChatListItem(chatRecord: chatrecords[index], onUpdateCR: get_ChatRecords,);
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildIconWithBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: EdgeInsets.all(16), // Padding around the content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '常見痠痛',
            style: TextStyle(
              color: Color.fromRGBO(56, 107, 79, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8), // Space between the title and icons
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: iconData.map((data) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => _showIconInfo(data),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.all(8),
                      child: Center(
                        child: Image.asset(
                          data['asset'],
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4), // Space between icon and text
                  Text(
                    data['title'], // 使用iconData中的title作為說明文字
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(56, 107, 79, 1),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showIconInfo(Map data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(data['description']),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  launch(data['url']);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromRGBO(56, 107, 79, 1), // Set the text color to green
                ),
                child: Text('Learn More'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(56, 107, 79, 1),
                foregroundColor: Colors.white, // Set the text color to white
              ),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ChatListItem extends StatelessWidget {
  final ChatRecord chatRecord;
  final dynamic Function() onUpdateCR;
  ChatListItem({required this.chatRecord, required this.onUpdateCR});

  void _handlePressed() {
    onUpdateCR();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chatRecord.name),
      onTap: _handlePressed,
    );
  }
}

