import 'package:flutter/material.dart';
import 'package:view/widgets/card/collection_Card.dart';
import 'package:view/widgets/button/add_CL_Button.dart';
import 'package:view/constants/text_style.dart';

class CollectionListView extends StatefulWidget {
  const CollectionListView({super.key});

  @override
  State<CollectionListView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionListView> {

  List<String> collection_List = ['大腿拉伸', '小腿拉伸'];

  void getCollectionList() async{

  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void _updateCL(List<String> newList) {
      setState(() {
        collection_List = newList;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            "我的收藏",
            style: UI_TextStyle.Title_TextStyle
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 700.0,
            child:
            Scrollbar(
              child:ListView.builder(
                  itemCount: collection_List.length,
                  itemBuilder: (context, index) {
                    CollectionListCard collectionListCard = CollectionListCard(name: collection_List[index]);
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                      child: collectionListCard.getCard()
                    );
                  }
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
            width: 60.0,
            child: AddCLButton(CL: collection_List, onUpdateCL: _updateCL).getButton(context)
          ),
        ],
      ),
    );
  }
}
