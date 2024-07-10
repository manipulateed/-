import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'event_view.dart';
import 'search_View.dart'; // Import the new SearchView

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
  Map<DateTime, List<String>> _events = {};
  bool _showEvents = true;

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
                  builder: (context) => SearchView(events: _events),
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
                if (selectedDay.year == focusedDay.year && selectedDay.month == focusedDay.month) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _showEvents = true;
                  });
                } else {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _showEvents = false;
                  });
                }
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
                _selectedDay = _selectedDay;
                setState(() {
                  _showEvents = false;
                });
              },
              eventLoader: (day) {
                return _events[day] ?? [];
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
            if (_selectedDay != null ) ...[
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (_events[_selectedDay] != null && _events[_selectedDay]!.isNotEmpty) {
                    _navigateToEventView();
                  }
                },
                  child:
                  _events[_selectedDay] != null && _events[_selectedDay]!.isNotEmpty && _showEvents
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _events[_selectedDay]!.map((event) {
                      return Card(
                        color: Colors.green[50],
                        shadowColor: Colors.white,
                        margin: EdgeInsets.all(15),
                        child: ListTile(
                          title: Text(event),
                        ),
                      );
                    }).toList(),
                  )
                      : SizedBox.shrink(),
                ),

            ],
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event for ${DateFormat('yyyy-MM-dd').format(_selectedDay!)}'),
          content: TextField(
            controller: _eventController,
            decoration: InputDecoration(labelText: 'Event'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _events.putIfAbsent(_selectedDay!, () => []).add(_eventController.text);
                  _eventController.clear();
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEventView() async {
    final updatedEvents = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(
          selectedDay: _selectedDay!,
          events: _events[_selectedDay!]!,
        ),
      ),
    );


  if (updatedEvents != null) {
      setState(() {
        _events[_selectedDay!] = updatedEvents;
      });
    }
  }
}
