import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:view/services/Sour_Record_svs.dart';
import 'event_view.dart';
import 'search_View.dart';
import 'package:view/models/Sour_Record.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TextEditingController _eventController = TextEditingController();
  String user_id = '66435b426b52ed9b072dc0dd';

  List<SourRecord> _event = [];

  bool _showEvents = true;
  List<SourRecord> SR = [];

  @override
  void initState() {
    super.initState();
    getAllSR(user_id);
  }

  void getAllSR(String user_id) async {
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.getAllSR(user_id);
    setState(() {
      SR = service.SR;
      _event = SR;
    });
  }

  //新增記錄接後端
  void createSR(String user_id, String reason, String time) async{
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.createSR(user_id, reason, time);
  }

  //跳去event_view
  void _navigateToEventView(String id) async {
    final updatedEvents = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(
          record_id: id,
        ),
      ),
    );
    //回傳true, 更新
    if (updatedEvents != null) {
      getAllSR(user_id);
    }
  }
  
  //新增紀錄
  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        //看看dialog要不要改style
        return AlertDialog(
          title: Text('${DateFormat('yyyy-MM-dd').format(_selectedDay!)}',
          textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: _eventController,
            //提示字可改
            //decoration: InputDecoration(labelText: 'Event'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
               onPressed: () {
                 String time = DateFormat('yyyy-MM-dd').format(_selectedDay!);
                 createSR(user_id, _eventController.text, time);
                 Navigator.pop(context);
                 getAllSR(user_id);
                 _selectedDay = _selectedDay!;
                 setState(() {
                   _eventController.clear();
                 });
               },
              child: Text('確認'),
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(
        title: Text(
          '我的日記',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
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
          IconButton(onPressed: _showAddEventDialog, icon: Icon(Icons.add))
        ],
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
                // InkWell(
                //   child: _getEventsForDay(_selectedDay!).isNotEmpty && _showEvents
                //       ? Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: _getEventsForDay(_selectedDay!).map((event) {
                //       return GestureDetector(
                //         onTap: () {
                //           // 使用 event.id
                //           _navigateToEventView(event.id);
                //         },
                //         child: Card(
                //           color: Colors.green[50],
                //           shadowColor: Colors.white,
                //           margin: EdgeInsets.all(15),
                //           child: ListTile(
                //             title: Text(event.reason),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //   )
                //       : SizedBox.shrink(),
                // ),
                Expanded(
                  child: _getEventsForDay(_selectedDay!).isNotEmpty && _showEvents
                      ? ListView.builder(
                          itemCount: _getEventsForDay(_selectedDay!).length,
                          itembuilder: (contex, index){
                            final entry = _getEventsForDay(_selectedDay!)[index]; //?
                            return Card(
                              color: Color.green[50],
                              shadowColor: Color.white,
                              margin: EdgeInsets.all(10),
                              child:ListTitle(
                                title: Text(entry.reason),
                              ),
                              onTap:() => _navigatoEventView(entry.id),
                            );
                          },
                      ) : SizedBox.shrink(),               
                ),

              
              ],
          ],
        ),
      ),
    );
  }
}
