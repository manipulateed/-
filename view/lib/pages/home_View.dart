import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Text('熱門痠痛部位',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                    child: Text('檢視所有分類',
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                        // 每個子元素都間隔右邊 16 單位
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Column(
                          // 子元素分成兩部分，圓角灰底的方形將用於顯示圖片 與 新聞來源的文字
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0,0),
                                    )
                                  ]
                                ),
                                child: Text('背部',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey,
                  ),
                ],
              ),
          ],
    );
  }
}
