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
      day = '${record.time.year}-${record.time.month}-${record.time.day}';
      reason = '${record.reason}';
      video = record.videos;
      id = '${record.id}';

      for (var map in video) {
        options.addAll(map.keys);
      }

      _controllers.add(TextEditingController(text: reason));

      print("資料"+day+reason+title+video.toString());
    }

    // _updatedEvents = widget.events.map((SR) {
    //   _controllers.add(TextEditingController(text: reason));
    //   return SourRecord(
    //     id: SR.id,
    //     userId: SR.userId,
    //     videos: SR.videos,
    //     title: SR.title,
    //     reason: SR.reason,
    //     time: SR.time,
    //   );
    // }).toList();

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
          content: Text('Events saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      //Navigator.pop(context, _updatedEvents);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event description cannot be empty'),
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
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
        appBar: AppBar(
          title: Text(
            day,
            //"Hello",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
          ),
          centerTitle: true,
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
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                '痠痛原因',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(96, 178, 133, 1)),
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
                          hintText: 'Enter reason',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: 400,
                      padding: EdgeInsets.fromLTRB(30.0, 16.0, 30.0, 16.0),
                      margin: EdgeInsets.symmetric(vertical: 30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        reason,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                }).toList(),
              ),

              Text(
                '推薦影片',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(96, 178, 133, 1)),
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
                        return _buildOptionButton(options[index], nonNullList);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
  
  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}