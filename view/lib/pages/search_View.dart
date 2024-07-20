import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';

import 'event_view.dart'; // 导入 EventView 组件

class SearchView extends StatefulWidget {
  final Map<DateTime, List<String>> events;

  const SearchView({Key? key, required this.events}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  List<MapEntry<DateTime, String>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchEvents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchEvents);
    _searchController.dispose();
    super.dispose();
  }

  void _searchEvents() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = <MapEntry<DateTime, String>>[];
    widget.events.forEach((date, events) {
      for (var event in events) {
        if (event.toLowerCase().contains(query)) {
          results.add(MapEntry(date, event));
        }
      }
    });

    setState(() {
      _searchResults = results;
    });
  }


  void _navigateToEventView(DateTime date, String event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(
          selectedDay: date,
          events: widget.events[date]!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜尋'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '關鍵字',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear(); // 清除文本
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('搜尋結果將顯示於此。'))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final entry = _searchResults[index];
                  //final dateStr = DateFormat('yMMMd', 'zh_TW').format(entry.key);
                  return Card(
                    color: Colors.green[50],
                    shadowColor: Colors.white,
                    margin: EdgeInsets.all(10),
                   // 設置內邊距
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                DateFormat('MMM').format(entry.key).toUpperCase(), // 顯示月份縮寫
                                style: TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold), // 文字顏色為灰色
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                DateFormat('d').format(entry.key), // 顯示日期
                                  style: TextStyle(color: Colors.green, fontSize: 24.0), // 文字顏色為白色
                              ),
                            ),
                          ],
                        ),
                      ),

                      title: Text(
                        entry.value,
                        style: TextStyle(fontSize: 16.0,), // 設置字體大小為 16
                      ),

                      onTap: () => _navigateToEventView(entry.key, entry.value),
                    ),
                  );
                },
              )

            ),
          ],
        ),
      ),
    );
  }
}
