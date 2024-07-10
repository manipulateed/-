import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class EventView extends StatefulWidget {
  final DateTime selectedDay;
  final List<String> events;

  EventView({required this.selectedDay, required this.events});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  List<TextEditingController> _controllers = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    widget.events.forEach((description) {
      _controllers.add(TextEditingController(text: description));
    });
  }

  void _editEvent() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveEvent() {
    bool isValid = true;
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        isValid = false;
        break;
      }
    }
    if (isValid) {
      setState(() {
        _isEditing = false;
        // 更新事件描述列表
        widget.events.clear();
        widget.events.addAll(_controllers.map((controller) => controller.text));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Events saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event description cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _deleteEvent() {
    setState(() {
      // 清空事件描述和控制器
      widget.events.clear();
      _controllers.clear();
    });
    // 返回上一頁並傳遞更新後的事件列表
    Future.delayed(Duration.zero, () {
      Navigator.pop(context, widget.events);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Events deleted successfully'),
          backgroundColor: Colors.green,
        ),
    );
  }


  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteEvent();
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // 在返回时执行保存操作
      Navigator.pop(context, widget.events);
      return true; // 允许返回
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('yyyy.MM.dd').format(widget.selectedDay),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
        ),
        centerTitle: true,
        actions: [
          _isEditing?
              IconButton(
                  onPressed: _saveEvent,
                  icon: Icon(Icons.save),
                  tooltip: 'Save Event',
              ):
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEvent();
              } else if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('編輯'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('刪除',style: TextStyle(color: Colors.red),),
                ),
              ];
            },
          ),
        ],
      ),
      body:Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [
            SizedBox(height: 20,),
            Text(
              '痠痛原因',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromRGBO(96, 178, 133, 1)),
            ),
            Column(
              children: _controllers.map((controller) {
                if (_isEditing) {
                  return Column(
                    children: _controllers.map((controller) {
                      return Padding(
                        padding: const EdgeInsets.all(30.0), // 设置左侧间距为20
                        child: TextField(
                          controller: controller,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Enter rabbit number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                else{
                    return Container(
                      width: 400,
                      padding: EdgeInsets.fromLTRB(30.0, 16.0, 30.0, 16.0),
                      margin: EdgeInsets.symmetric(vertical: 30.0),
                      decoration: BoxDecoration(
                        //color: Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        controller.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20
                        ),// 將文字置中
                      ),
                    );
                  }
              }).toList(),
            ),

            Text(
              '推薦影片',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromRGBO(96, 178, 133, 1)),
            ),

            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    String url = 'https://www.youtube.com/watch?v=XGRQMgQ0N-0&list=PL274L1n86T839P6Bqd3M2knHhLjU0wRMG&index=7';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                    else {
                      throw '無法打開 $url';
                    }
                  },
                  child:
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:  Text(
                      '這是一個超連結',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),

                ),
              ],
            )


          ],
        ),
      ),
    ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
