import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:view/constants/route.dart';

class ThroughView extends StatefulWidget {
  const ThroughView({super.key});

  @override
  State<ThroughView> createState() => _ThroughViewState();
}

class _ThroughViewState extends State<ThroughView> {
  Future<void> route_to_login() async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, Routes.baseview);
  }

  @override
  void initState(){
    super.initState();
    route_to_login();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF81C784),
      body: Center(
        child: SpinKitPulsingGrid(
          color: Colors.white,
          size: 68.0,
        ),
      ),
    );
  }
}
