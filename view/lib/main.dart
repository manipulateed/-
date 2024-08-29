
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:view/constants/route.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginState = prefs.getString("jwt_token");

  await initializeDateFormatting('zh_TW', null);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: loginState == null ? Routes.loginview: Routes.baseview,
    routes: Routes.getRoutes(),
  ));
}



