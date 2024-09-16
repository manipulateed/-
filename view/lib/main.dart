
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:view/constants/route.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:view/constants/config.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  var loginState = prefs.getString("jwt_token");

  await Config.load();

  await initializeDateFormatting('zh_TW', null);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  print(loginState);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: loginState == null ? Routes.loginview: Routes.baseview,
    routes: Routes.getRoutes(),
  ));
}



