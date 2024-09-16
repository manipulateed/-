import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';

import 'event_view.dart'; // 导入 EventView 组件
import 'package:view/services/Sour_Record_svs.dart';
import 'package:view/models/Sour_Record.dart';

class SearchView extends StatefulWidget {
  //final Map<DateTime, List<String>> events;

  final String user_id;

  const SearchView({Key? key, required this.user_id}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  //將time、reason、id 加入 search result

  List<SourRecord> result = [];
  List<SourRecord> _searchResults = [];
  List<SourRecord> SR = [];
  String temp ="";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchEvents);
    getAllSR();
  }

  @override
  void getAllSR() async {
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.getAllSR();
    setState(() {
      SR = service.SR;
    });
  }

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

    result.clear();

    for (var record in SR) {
      if (record.reason.contains(query)) {
        if(!_searchResults.contains(query)){
          result.add(record);
        }
      }
    }

    setState(() {
      _searchResults = result;
    });
  }

  //透過id進到event_view
  void _navigateToEventView(id) async{
    final updatedEvents = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventView(
          record_id: id,
        ),
      ),
    );

    temp = _searchController.text;

    if (updatedEvents != null) {
      getAllSR();
      _searchController.clear();
      _searchController.text = temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('搜尋'),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                    _searchController.clear();

                    setState(() {
                      _searchResults = [];
                    });
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
                                  DateFormat('MMM')
                                      .format(entry.time)
                                      .toUpperCase(), // 顯示月份縮寫
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                      fontWeight:
                                      FontWeight.bold), // 文字顏色為灰色
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  DateFormat('d')
                                      .format(entry.time), // 顯示日期
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 24.0), // 文字顏色為白色
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          entry.reason,
                          style: TextStyle(
                            fontSize: 16.0,
                          ), // 設置字體大小為 16
                        ),
                        onTap: () => _navigateToEventView(entry.id),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}