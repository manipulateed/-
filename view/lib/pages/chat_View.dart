import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:view/models/Chat_Record.dart';
import 'package:view/models/Video.dart';
import 'package:view/constants/route.dart';
import 'package:view/services/callGPT_svs.dart';
import 'package:view/services/chatrecord_svs.dart';
// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}


class _ChatViewState extends State<ChatView> {

  final List<types.Message> _messages = [];//歷史訊息列表
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');//user 自己
  late ChatRecord chatrecord;

  //取得前一頁傳遞進來的 資料
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatrecord = ModalRoute.of(context)!.settings.arguments as ChatRecord;
    if (_messages.length == 0)
      getChatRecord();
  }

  void getChatRecord(){
    for (var message in chatrecord.message) {
      if (message["Role"] == 'User' || message["Role"] == 'user') {
        final textMessage = types.TextMessage(
          author: _user,//自己
          createdAt: DateTime.now().millisecondsSinceEpoch,//訊息建立時間，我個人偏向使用伺服器的時間
          id: randomString(),//每一個message要有獨立的id
          text: message["Content"].toString(),//文字訊息
        );

        _addMessage(textMessage);
        print('User Message: ${message["Content"]}');
      } else if (message["Role"] == 'AI'|| message["Role"] == 'ai') {
        // AI 發送的訊息，執行相應的動作
        final textMessage = types.TextMessage(
          author:types.User(id: 'bot'),
          createdAt: DateTime.now().millisecondsSinceEpoch,//訊息建立時間，我個人偏向使用伺服器的時間
          id: randomString(),//每一個message要有獨立的id
          text: message["Content"].toString(),//文字訊息
        );

        _addMessage(textMessage);
        print('AI Message: ${message["Content"]}');
      } else {
        // 其他角色的訊息處理
        print('Other Message: ${message["Content"]}');
      }
    }
  }

  Future<Map<String, dynamic>> getReponse(String message)async{
    CallGPT_SVS service = CallGPT_SVS(message: message);
    await service.getDignose(chatrecord.id);

    if (service.finish == "True"){
      chatrecord.suggestedVideoIds = service.suggestMap;
      chatrecord.finish = "yes";
    }

    return service.response;
  }

  void updateRecord() async{
    Chatrecord_SVS service = Chatrecord_SVS(chatrecords: [chatrecord]);
    await service.updateChatRecord();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double halfScreenWidth = screenWidth / 5;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.fromLTRB(halfScreenWidth,0,0,0),
          child: Text(chatrecord.name),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context, true);
          }
        )
      ),
      body: Stack(
        children: [
          Chat(
            messages: _messages,
            onSendPressed:  _handleSendPressed,
            user: _user,
            inputOptions: InputOptions(
              enabled: !(chatrecord.finish == "yes"),
            ),
            //scrollController: _scrollController,
            theme: DefaultChatTheme(
              inputBackgroundColor: Colors.grey[200]!,
              inputTextColor: Colors.black,
              primaryColor: Color.fromRGBO(95, 178, 132, 0.8),
              backgroundColor: Colors.white,
              messageInsetsHorizontal: 10,
              messageInsetsVertical: 10,
              userAvatarNameColors: [Colors.black],
              receivedMessageBodyTextStyle: TextStyle(color: Colors.black),
              sentMessageBodyTextStyle: TextStyle(color: Colors.white),
            ),
          ),
          if (chatrecord.finish == "yes") Positioned(
            top: 30,
            left: 20,
            child: FloatingActionButton(
              onPressed: _showImprovementOptions,
              child: Icon(Icons.list),
              backgroundColor: Color.fromRGBO(95, 178, 132, 0.8),
            ),
          ),
        ],
      ),
   );
  }

  void _addMessage(types.Message message) {
    setState(() {
      //新增新訊息時，將資料插入到index 0的位置，並且setState刷新UI
      _messages.insert(0, message);
    });
  }

  //將message轉成map
  void convertMessageToMapandAddtoRecord(types.TextMessage message, String author) {
    chatrecord.message.add({
      'character': author,
      'content': message.text,
      'date': DateTime.fromMillisecondsSinceEpoch(int.parse(message.createdAt.toString())).toIso8601String().split('T')[0],
      'time': DateTime.fromMillisecondsSinceEpoch(int.parse(message.createdAt.toString())).toIso8601String().split('T')[1],
    });
  }

  //當點擊send按鈕時，會從Chat Widget中觸發此函數並將訊息資料傳出。
  //根據資料內容可以創建新的`TextMessage`並加入訊息歷史列表中
  void _handleSendPressed (types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,//自己
      createdAt: DateTime.now().millisecondsSinceEpoch,//訊息建立時間，我個人偏向使用伺服器的時間
      id: randomString(),//每一個message要有獨立的id
      text: message.text,//文字訊息
    );
    _addMessage(textMessage);

    //將梁天記錄轉換成MAP並存到chatrecord中
    convertMessageToMapandAddtoRecord(textMessage, "User");

    Map<String, dynamic> response = await getReponse(message.text);

    final replyMessage = types.TextMessage(
      author: types.User(id: 'bot'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: response["content"].toString(),
    );
    _addMessage(replyMessage); // 插入對方的回覆訊息

    convertMessageToMapandAddtoRecord(replyMessage, "AI");

    //更新醉心聊天紀錄
    updateRecord();
  }

  void _showImprovementOptions() {
    setState(() {
      _messages.clear();
    });
    List<Map<String, List<Video>>> videoMaps = chatrecord.suggestedVideoIds;
    List<String> options = [];

    for (var map in videoMaps) {
      options.addAll(map.keys);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('改善方向'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                List<Video> nonNullList = chatrecord.suggestedVideoIds[index][options[index]] ?? [];
                return _buildOptionButton(options[index], nonNullList);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('關閉'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 定義 _buildOptionButton 方法
  Widget _buildOptionButton(String label, List<Video> videos ) {
    return ElevatedButton(
      onPressed: () {
        // 在這裡處理按鈕點擊事件
        Navigator.pushNamed(context, Routes.videoView, arguments: videos); // 點擊按鈕後關閉對話框
      },
      child: Text(label),
    );
  }
}