import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:view/constants/route.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {

  final List _pages = Routes.pages;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Center(
      //     child: Text(
      //       "酸通",
      //       style: TextStyle(
      //         fontSize: 30,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFFB2DFDB),
              size: 50,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              color: Color(0xFFB2DFDB),
              size: 50,
            ),
            label: 'Star',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Color(0xFFB2DFDB),
              size: 50,
            ),
            label: 'Talk',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFFB2DFDB),
              size: 50,
            ),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Color(0xFFB2DFDB),
              size: 50,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.teal[200],
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: _pages[currentPageIndex],
    );
  }
}