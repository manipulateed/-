import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:view/services/Sour_Record_svs.dart';
import 'event_view.dart';
import 'search_View.dart';
import 'package:view/models/Sour_Record.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();
  String user_id='';
  String record_id='';
  List<SourRecord> _event = [];

  bool _showEvents = true;
  List<SourRecord> SR = [];

  @override
  void initState() {
    super.initState();
    getAllSR();
    FlutterNativeSplash.remove();
  }

  void getAllSR() async {
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.getAllSR();
    setState(() {
      SR = service.SR;
      _event = SR;
    });
  }

  void createSR(String user_id, String reason, String time) async{
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.createSR(user_id, reason, time);
    getAllSR();
  }

  //跳至event_view.dart
  void _navigateToEventView(String id) async {
    //final events = _getEventsForDay(_selectedDay!);
    final updatedEvents = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(
          record_id: id,
        ),
      ),
    );

    //若從上一頁返回有回傳true，更新資料
    if (updatedEvents != null) {
      getAllSR();
    }
  }

  List<SourRecord> _getEventsForDay(DateTime day) {
    return _event.where((record) {
      DateTime recordDate = DateTime(record.time.year, record.time.month, record.time.day);
      return isSameDay(recordDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text(
          '我的日記',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
            letterSpacing: 3
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search), // 根據編輯狀態顯示圖標
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchView(user_id: user_id),
                ),
              );
            }, // 設置按下按鈕時執行的函數
          ),
          //新增日記
          IconButton(onPressed: _showAddEventDialog, icon: Icon(Icons.add))
        ],
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                  _focusedDay = focusedDay;
                  _showEvents = true;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                setState(() {
                  _showEvents = false;
                });
              },
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green[600],
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1.5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
            SizedBox(height: 20),
            if (_selectedDay != null)
              ...[
                SizedBox(height: 20),
                Expanded(
                  child: _getEventsForDay(_selectedDay!).isNotEmpty && _showEvents
                      ? ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      final entry = _getEventsForDay(_selectedDay!)[index];
                      return GestureDetector(
                        onTap: () => _navigateToEventView(entry.id),
                        child: Card(
                          color: Colors.green[50],
                          shadowColor: Colors.white,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(entry.reason),
                          ),
                        ),
                      );
                    },
                  )
                    : SizedBox.shrink(),
                ),
              ],
          ],
        ),
      ),
    );
  }

  //新增紀錄
  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${DateFormat('yyyy-MM-dd').format(_selectedDay!)}',
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: _eventController,
            decoration: InputDecoration(labelText: '請輸入文字'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async{
                String time = DateFormat('yyyy-MM-dd').format(_selectedDay!);
                Navigator.pop(context);
                createSR(user_id, _eventController.text, time);
                _selectedDay = _selectedDay!;
                setState(() {
                  _eventController.clear();
                });
              },
              child: Text('新增'),
            ),
          ],
        );
      },
    );
  }
}
