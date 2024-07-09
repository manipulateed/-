import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class ChatView extends StatefulWidget {
  const ChatView({super.key});


  @override
  //_ChatViewState createState() => _ChatViewState();
  State<ChatView> createState() => _ChatViewState();
}


class _ChatViewState extends State<ChatView> {
  final List<types.Message> _messages = [];//歷史訊息列表
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');//user 自己
  final _chatBot = const types.User(id: 'chatBot_id'); // 假設有一個不同的對方用戶 ID

  late final types.TextMessage replyMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Stack(
        children: [
          Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
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
              //receivedMessageBackgroundColor: Colors.grey[300]!,
              //sentMessageBackgroundColor: Colors.blue,
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
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
        ],
      ),
      floatingActionButton:
        FloatingActionButton(
          onPressed: _showImprovementOptions,
          child: Icon(Icons.list),
          backgroundColor: Color.fromRGBO(95, 178, 132, 0.8),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }


  void _addMessage(types.Message message) {
    setState(() {
      //新增新訊息時，將資料插入到index 0的位置，並且setState刷新UI
      _messages.insert(0, message);
    });
  }

  _ChatViewState() {
    replyMessage = types.TextMessage(
      author: _chatBot,
      createdAt: DateTime
          .now()
          .millisecondsSinceEpoch + 1000,
      id: randomString(),
      text: 'This is a reply from the other user.',
    );
  }

  //當點擊send按鈕時，會從Chat Widget中觸發此函數並將訊息資料傳出。
  //根據資料內容可以創建新的`TextMessage`並加入訊息歷史列表中
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,//自己
      createdAt: DateTime.now().millisecondsSinceEpoch,//訊息建立時間，我個人偏向使用伺服器的時間
      id: randomString(),//每一個message要有獨立的id
      text: message.text,//文字訊息
    );

    _addMessage(textMessage);
    _addMessage(replyMessage); // 插入對方的回覆訊息

  }
  void _showImprovementOptions() {
    List<String> options = [
      '休息和恢復',
      '冰敷',
      '热敷',
      '輕度運動',
      '放鬆運動',
      '按摩',
      '營養食補',
      '伸展和肌肉訓練',
      // 添加更多改善方向...
    ];

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
                return _buildOptionButton(options[index]);
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
  Widget _buildOptionButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // 在這裡處理按鈕點擊事件
        print('Selected option: $label');
        Navigator.of(context).pop(); // 點擊按鈕後關閉對話框
      },
      child: Text(label),
    );
  }
}










