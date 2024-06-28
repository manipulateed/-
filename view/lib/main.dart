
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:view/constants/route.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginState = prefs.getString("loginState");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: loginState == null ? Routes.loginview : Routes.baseview,
    routes: Routes.getRoutes(),
  ));
}



