import 'package:flutter/material.dart';
import 'package:view/models/Chat_Record.dart';
import 'package:view/services/chatrecord_svs.dart';
import 'package:view/constants/route.dart';
import 'package:quickalert/quickalert.dart';

class ChatroomView extends StatefulWidget {
  const ChatroomView({super.key});

  @override
  State<ChatroomView> createState() => _ChatroomViewState();
}

class _ChatroomViewState extends State<ChatroomView> {

  List<ChatRecord> chatrecords = [];

  Future<void> get_ChatRecords() async{
    Chatrecord_SVS service = new Chatrecord_SVS(chatrecords:chatrecords);
    await service.getAllChatRecords();
    setState(() {
      chatrecords = service.chatrecords.reversed.toList();
      chatrecords.sort((a, b) {
        DateTime dateTimeA = DateTime.parse(a.timestamp);
        DateTime dateTimeB = DateTime.parse(b.timestamp);
        return dateTimeB.compareTo(dateTimeA); // 由晚到早排列
      });
    });
  }

  Future<void> createChatRecord(ChatRecord chatrecord) async{
    chatrecords.add(chatrecord);
    Chatrecord_SVS service = new Chatrecord_SVS(chatrecords:chatrecords);
    await service.createChatRecord();
    await get_ChatRecords();
  }

  @override
  void initState() {
    super.initState();
    // 在這裡初始化你的聊天紀錄
    get_ChatRecords();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('酸通診療室',
          style: TextStyle(
            color: Color.fromRGBO(56, 107, 79, 1),
            fontWeight: FontWeight.bold,
            letterSpacing: 3
          )
        ),
        backgroundColor: Colors.green[100],
        elevation: 3,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Material(
              color: Colors.transparent, // 改為白色，確保 InkWell 有效果
              child: InkWell(
                onTap: () async {
                  String message = "";
                  late ChatRecord chatRecord;
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.custom,
                    barrierDismissible: true,
                    cancelBtnText: '取消',
                    confirmBtnText: '確認新增',
                    title: '新增Chat Room',
                    confirmBtnColor: Colors.green,
                    widget: TextFormField(
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        hintText: '請輸入名稱',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) => chatRecord = new ChatRecord(id: "", userId: "", message: [], suggestedVideoIds: [], name: value, timestamp: "", finish: "no"),
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
                      if (result == true) {
                        await get_ChatRecords();
                      }
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(232, 248, 234, 1), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: Icon(Icons.add, color: Color.fromRGBO(56, 107, 79, 1)),
                      ),
                      SizedBox(width: 70),
                      Center(
                        child: Text(
                          'New Chat',
                          style: TextStyle(
                            color: Color.fromRGBO(56, 107, 79, 1),
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


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
}

class ChatListItem extends StatelessWidget {
  final ChatRecord chatRecord;
  dynamic Function() onUpdateCR;
  ChatListItem({required this.chatRecord, required this.onUpdateCR});

  Future<void> _handlePressed() async{
    await onUpdateCR();
  }

  Future<void> removeChatRoom(String id) async {
    List<ChatRecord> chatrecords = [];
    Chatrecord_SVS service = new Chatrecord_SVS(chatrecords:chatrecords);
    await service.deleteCR(id);
    _handlePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(232, 248, 234, 1), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            Icons.ac_unit_sharp,
            size: 40,
          ),
          title: Text(
            chatRecord.name,
            style: TextStyle(
              color: Color.fromRGBO(56, 107, 79, 1),
              letterSpacing: 2
            ),
          ),
          subtitle: Text(
            chatRecord.timestamp.replaceAll("T", " ").replaceAll(RegExp(r'\.\d+'), ' '),
            style: TextStyle(
              color: Color.fromRGBO(56, 107, 79, 0.5),
              letterSpacing: 1.5
            ),),
          onTap: () async{
            final result = await Navigator.pushNamed(context, Routes.chatView, arguments: chatRecord);
            if (result == true){
              await _handlePressed();
            }
            // Handle chat item tap
          },
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: () async{
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                confirmBtnText: '確認刪除',
                title: '確定要刪除此聊天室?',
                confirmBtnColor: Colors.green,
                cancelBtnText: '取消',
                text: '請確定是否要刪除此聊天室?',
                onConfirmBtnTap: () async {
                  try {
                    removeChatRoom(chatRecord.id);

                    Navigator.pop(context);
                    print("Close the confirmation dialog");

                    // Short delay before showing success message
                    await Future.delayed(const Duration(milliseconds: 300));

                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "已刪除聊天室!",
                    );
                    print("已刪除聊天室");

                  } catch (e) {
                    print("Error: ${e.toString()}");

                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: "處理過程中出錯了",
                    );
                    print("處理過程中出錯了");
                  }
                },
                onCancelBtnTap: () {
                  Navigator.pop(context);  // Close the confirmation dialog if canceled
                },
              );
            },
          ),
        ),
      ),
    );
  }
}