import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui';

class MyCustomScrollBehavior extends ScrollBehavior {

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  bool shouldNotify(covariant ScrollBehavior oldDelegate) {
    return false;
  }

  /*@override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
    };
  }*/
}