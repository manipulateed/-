import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:view/pages/my_flutter_app_icons.dart';
import 'package:view/pages/frontbody_View.dart';
import 'package:view/pages/backbody_View.dart';

class MuscleAreaView extends StatefulWidget {
  const MuscleAreaView({super.key});

  @override
  State<MuscleAreaView> createState() => _MuscleAreaViewState();
}

class _MuscleAreaViewState extends State<MuscleAreaView> {

  bool isFrontSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(222, 229, 223, 1),
      appBar: AppBar(
        title: Text('Where your pain...?'),
        backgroundColor: Color.fromRGBO(222, 229, 223, 1)
      ),
      body: Column(
        children: [
          isFrontSelected ? FrontbodyView() : BackbodyView(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Container(
              width: 240.0, // 設置外層 Container 的寬度
              height: 50.0,
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 255, 251, 0.7),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFrontSelected = false;
                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: !isFrontSelected ? Color.fromRGBO(74, 132, 100, 0.5) : Color.fromRGBO(250, 255, 251, 0.7),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      child: Text(
                        'BACK',
                        style: TextStyle(
                          color: !isFrontSelected ? Colors.white : Color.fromRGBO(74, 132, 100, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFrontSelected = true;
                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: isFrontSelected ? Color.fromRGBO(74, 132, 100, 0.5) : Color.fromRGBO(250, 255, 251, 0.7),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      child: Text(
                        'FRONT',
                        style: TextStyle(
                          color: isFrontSelected ? Colors.white : Color.fromRGBO(74, 132, 100, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
