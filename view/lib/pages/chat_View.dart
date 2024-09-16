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
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  late ChatRecord chatrecord;
  final ValueNotifier<String> _finishNotifier = ValueNotifier<String>("");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatrecord = ModalRoute.of(context)!.settings.arguments as ChatRecord;
    if (_messages.isEmpty) {
      getChatRecord();
      if (_messages.isEmpty){
        final replyMessage = types.TextMessage(
          author: types.User(id: 'bot'),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: randomString(),
          text: "請問您哪裡痠痛呢?",
        );
        _addMessage(replyMessage);

        convertMessageToMapandAddtoRecord(replyMessage, "AI");
      }
    }

    // Update ValueNotifier when chatrecord.finish changes
    _finishNotifier.value = chatrecord.finish;
  }

  @override
  void initState() {
    super.initState();

    // Update the ValueNotifier when finish status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _finishNotifier.addListener(() {
        if (_finishNotifier.value == "yes") {
          final position = Offset(90, 120); // Set your desired position
          showTooltip(context, '點擊查看舒緩關鍵字', position);
        }
      });
    });
  }

  @override
  void dispose() {
    _finishNotifier.dispose();
    super.dispose();
  }

  void getChatRecord() {
    for (var message in chatrecord.message) {
      // 組合日期和時間
      String dateTimeString = "${message['date']} ${message['time']}";

      if (message["character"] == 'User' || message["character"] == 'user') {
        final textMessage = types.TextMessage(
          author: _user,
          createdAt: DateTime.parse(dateTimeString.replaceAll(" ", "T")).millisecondsSinceEpoch,
          id: randomString(),
          text: message["content"].toString(),
        );
        _addMessage(textMessage);
      } else if (message["character"] == 'AI' || message["character"] == 'ai') {
        final textMessage = types.TextMessage(
          author: types.User(id: 'bot'),
          createdAt: DateTime.parse(dateTimeString.replaceAll(" ", "T")).millisecondsSinceEpoch,
          id: randomString(),
          text: message["content"].toString(),
        );
        _addMessage(textMessage);
      }
    }
  }

  Future<Map<String, dynamic>> getReponse(String message) async {
    _showLoadingAnimation();
    CallGPT_SVS service = CallGPT_SVS(message: message);
    await service.getDignose(chatrecord.id);
    Navigator.pop(context);
    if (service.finish == "True") {
      chatrecord.suggestedVideoIds = service.suggestMap;
      chatrecord.finish = "yes";
      _finishNotifier.value = chatrecord.finish; // Notify listeners about the change
    }

    return service.response;
  }

  void updateRecord() async {
    print(chatrecord.message);
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
        title:  Text(
          chatrecord.name,
          style: TextStyle(
              color: Color.fromRGBO(56, 107, 79, 1),
              fontWeight: FontWeight.bold,
              letterSpacing: 3
          )
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.green[100],
      ),
      body: Stack(
        children: [
          Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
            inputOptions: InputOptions(
              enabled: !(chatrecord.finish == "yes"),
            ),
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
          ValueListenableBuilder<String>(
            valueListenable: _finishNotifier,
            builder: (context, finishStatus, child) {
              if (finishStatus == "yes") {
                return Positioned(
                  top: 30,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: _showImprovementOptions,
                    child: Icon(Icons.list),
                    backgroundColor: Color.fromRGBO(95, 178, 132, 0.8),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void convertMessageToMapandAddtoRecord(types.TextMessage message, String author) {
    chatrecord.message.add({
      'character': author,
      'content': message.text,
      'date': DateTime.fromMillisecondsSinceEpoch(int.parse(message.createdAt.toString())).toIso8601String().split('T')[0],
      'time': DateTime.fromMillisecondsSinceEpoch(int.parse(message.createdAt.toString())).toIso8601String().split('T')[1],
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);

    convertMessageToMapandAddtoRecord(textMessage, "User");

    Map<String, dynamic> response = await getReponse(message.text);

    final replyMessage = types.TextMessage(
      author: types.User(id: 'bot'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: response["content"].toString(),
    );
    _addMessage(replyMessage);

    convertMessageToMapandAddtoRecord(replyMessage, "AI");
    print(chatrecord.message);
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
          title: Center(
            child: Text(
              '改善方向',
                style: TextStyle(
                  color: Color.fromRGBO(56, 107, 79, 1),
                )
            ),
          ),
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

  //產生影片推薦按鈕
  Widget _buildOptionButton(String label, List<Video> videos) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.videoView, arguments: videos);
        },
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 2.0
          ),
        ),
      ),
    );
  }

  //產生影片推薦提示
  void showTooltip(BuildContext context, String message, Offset position) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _showLoadingAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(250, 255, 251, 1),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('機器人正在生成與分析...'),
            ],
          ),
        );
      },
    );
  }
}
