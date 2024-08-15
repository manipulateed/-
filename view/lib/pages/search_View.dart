import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';
import 'event_view.dart'; // 导入 EventView 组件
import 'package:view/services/Sour_Record_svs.dart';
import 'package:view/models/Sour_Record.dart';

class SearchView extends StatefulWidget {
  //final Map<DateTime, List<String>> events; 刪

  final String user_id;

  const SearchView({Key? key, required this.user_id}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  //將time、reason、id 加入 search result

  //感覺可以把result刪了
  List<SourRecord> result = [];
  List<SourRecord> _searchResults = [];
  List<SourRecord> SR = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchEvents);
    getAllSR(widget.user_id);
  }

  @override
  void getAllSR(String user_id) async {
    Sour_Record_SVS service = Sour_Record_SVS(SR: SR);
    await service.getAllSR(user_id);
    setState(() {
      SR = service.SR;
      //_event = SR;
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

    //這裡直接用_searchResults?
    for (var record in SR) {
      if (record.reason.contains(query)) {
        result.add(record);
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

    if (updatedEvents != null) {
      getAllSR(widget.user_id);
      // 改 _searchEvents() ;
      _searchController.addListener(_searchEvents);
    }  
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
                          //final dateStr = DateFormat('yMMMd', 'zh_TW').format(entry.key); 刪
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
