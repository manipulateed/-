import 'package:flutter/material.dart';
import 'package:view/models/Chat_Record.dart';

class ChatroomView extends StatefulWidget {
  const ChatroomView({super.key});

  @override
  State<ChatroomView> createState() => _ChatroomViewState();
}

class _ChatroomViewState extends State<ChatroomView> {

  final List<ChatRecord> chatRecords = [
    ChatRecord(title: '肩膀', date: '2024.03.03'),
    ChatRecord(title: '手腕', date: '2024.03.03'),
    ChatRecord(title: '腳踝', date: '2024.03.03'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text('聊天', style: TextStyle(color: Color.fromRGBO(56, 107, 79, 1))),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child:  Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color.fromRGBO(232, 248, 234, 1), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                        // Handle new chat creation
                  },
                  child:Row(
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
                          style: TextStyle(color: Color.fromRGBO(56, 107, 79, 1), fontSize: 25),
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
              itemCount: chatRecords.length,
              itemBuilder: (context, index) {
                return ChatListItem(chatRecord: chatRecords[index]);
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

  ChatListItem({required this.chatRecord});

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
            chatRecord.title,
            style: TextStyle(
                color: Color.fromRGBO(56, 107, 79, 1)
            ),
          ),
          subtitle: Text(
            chatRecord.date,
            style: TextStyle(
                color: Color.fromRGBO(56, 107, 79, 0.5)
            ),),
          onTap: () {
            // Handle chat item tap
          },
        ),
      ),
    );
  }
}

class ChatRecord {
  final String title;
  final String date;

  ChatRecord({required this.title, required this.date});
}