
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:view/constants/route.dart';
import 'package:intl/date_symbol_data_local.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginState = prefs.getString("loginState");

  await initializeDateFormatting('zh_TW', null);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: loginState == null ? Routes.baseview : Routes.loginview,
    routes: Routes.getRoutes(),
  ));
}



