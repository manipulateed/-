import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:view/models/Sour_Record.dart';
import 'package:view/services/Sour_Record_svs.dart';
import 'package:view/models/Video.dart';
import 'package:view/constants/route.dart';

class EventView extends StatefulWidget {
  //final List<SourRecord> events;
  final String record_id ;

  EventView({required this.record_id});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  List<TextEditingController> _controllers = [];
  List<SourRecord> _updatedEvents = [];
  bool _isEditing = false;
  String day = '';
  String reason='';
  String title='';
  List<Map<String, List<Video>>> video=[];
  String id='';
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    getSR(widget.record_id);
  }

  List<SourRecord> SR = [];

  //獲取單一痠痛內容
  void getSR(id) async {
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.getSR(id);
    setState(() {
      SR = service.SR;
    });

    for (var record in SR) {
      day = '${record.time.year} 年 ${record.time.month} 月 ${record.time.day} 日';
      reason = '${record.reason}';
      video = record.videos;
      id = '${record.id}';

      for (var map in video) {
        options.addAll(map.keys);
      }

      _controllers.add(TextEditingController(text: reason));
    }
  }

  void updateSR(String id,String new_value) async {
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
      });
      Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
      await service.updateSR(id,new_value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('修改成功'),
          backgroundColor: Colors.green,
        ),
      );
      //Navigator.pop(context, _updatedEvents);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('不得為空白'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editEvent() {
    setState(() {
      _isEditing = true;
    });
  }

  void _deleteEvent(String id) async {
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.deleteSR(id);
    Navigator.pop(context,true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('刪除成功'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('你確定要刪除此紀錄嗎?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              child: Text('取消', style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('刪除', style: TextStyle(color: Colors.red),),
              onPressed: () {
                _deleteEvent(widget.record_id);
                Navigator.pop(context, true);
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
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE9F5EF),

        appBar: AppBar(
          backgroundColor: Colors.green[100],
          title: Text(
            day,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),

          ),
          centerTitle: true,
          elevation: 3,
          actions: [
            _isEditing
                ? IconButton(

              onPressed: () {
                // 收集所有 TextEditingController 中的文本内容，并将其作为 new_value 传递
                String newValue = _controllers.map((controller) => controller.text).join(", ");
                updateSR(widget.record_id, newValue);
                setState(() {
                  reason = newValue;
                });
              },
              icon: Icon(Icons.save),
              tooltip: 'Save Event',
            )
                : PopupMenuButton<String>(
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
                    child: Text('刪除', style: TextStyle(color: Colors.red)),
                  ),
                ];
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
        child: Center(
          child: Column(

            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    '痠痛原因',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 5.0,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800]
                    ),
                  ),
                ),
              ),



              Column(
                children: _controllers.map((controller) {
                  int index = _controllers.indexOf(controller);
                  if (_isEditing) {
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: TextField(
                        controller: controller,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '請輸入文字',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0), // 設置未聚焦時的邊框顏色
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 1.5), // 設置聚焦時的邊框顏色
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                      ),
                    );
                  } else {
                    return Container(
                      width: 400,
                        padding: const EdgeInsets.fromLTRB(30,10, 30, 10),
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                          boxShadow: [
                      BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 9,
                      offset: Offset(3, 5), // changes position of shadow
                    ),
                  ]
                      ),
                      child: Text(
                        reason,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 2.0
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),




              Visibility(
                visible: options.length > 1,
                child: Container(
                  width: 150,
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    '推薦影片',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 5.0,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),

                ),
              ),

              Column(
                children:  [
                  Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<Video> nonNullList = video[index][options[index]] ?? [];
                        return _buildOptionButton(options[index], nonNullList,);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
        ),
      ),
    );
  }

  // 定義 _buildOptionButton 方法
  Widget _buildOptionButton(String label, List<Video> videos ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30,10, 30, 10),
      child: ElevatedButton(
        onPressed: () {
          // 在這裡處理按鈕點擊事件
          Navigator.pushNamed(context, Routes.videoView, arguments: videos); // 點擊按鈕後關閉對話框
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // 設置按鈕背景顏色
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // 設置按鈕內邊距
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // 設置按鈕圓角
          ),
          elevation: 5, // 設置按鈕陰影
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
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