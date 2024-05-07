
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindpal_flutter_app/constants/routes.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginState = prefs.getString("loginState");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: loginState == null ? Routes.first : Routes.baseview,
    routes: Routes.getRoutes(),
  ));
}



