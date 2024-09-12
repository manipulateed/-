
import 'package:flutter/material.dart';
import 'package:view/pages/chat_View.dart';
import 'package:view/pages/base_View.dart';
import 'package:view/pages/chatroom_View.dart';
import 'package:view/pages/home_View.dart';
import 'package:view/pages/muscle_area_View.dart';
import 'package:view/pages/through_View.dart';
import 'package:view/pages/login_View.dart';
import 'package:view/pages/signup_View.dart';
import 'package:view/pages/collectionlist_View.dart';
import 'package:view/pages/account_View.dart';
import 'package:view/pages/calendar_View.dart';
import 'package:view/pages/event_View.dart';
import 'package:view/pages/collection_View.dart';
import 'package:view/pages/video_View.dart';


class Routes {

  static const String chatView = '/chatview';
  static const String baseview = '/baseview';
  static const String throughview = '/throughview';
  static const String loginview = '/loginview';
  static const String signupView = '/signupview';
  static const String collectionView = '/collectionview';
  static const String accountView = '/accountview';
  static const String calendarView = '/calendarview';
  static const String eventView = '/eventview';
  static const String collectView = '/collectview';
  static const String muscle_areaView = '/muscleareaview';
  static const String chatroomView = '/chatroomview';
  static const String videoView = '/videoview';
  static const String homeView = '/homeview';
  static const List pages = [HomeView(),CollectionListView(),ChatroomView(),CalendarView(), AccountView()];


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      chatView: (context) => ChatView(),
      baseview:(context)=> BaseView(),
      throughview:(context)=> ThroughView(),
      loginview:(context)=> LoginView(),
      signupView:(context)=> SignupView(),
      collectionView:(context)=> CollectionListView(),
      accountView: (context)=> AccountView(),
      calendarView: (context) => CalendarView(),
      //eventView: (context) => EventView(),
      collectView: (context)=> CollectionView(),
      muscle_areaView: (context)=> MuscleAreaView(),
      chatroomView: (context) => ChatroomView(),
      videoView: (context) => VideoView(),
      homeView: (context) => HomeView()


    };
  }
}
