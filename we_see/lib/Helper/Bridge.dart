import 'package:flutter/material.dart';

class BridgeView {

  /// Bot context and page param got from Viewpage before 

  // ! Do not use this method
  static routeTo(context, page) {
    return MaterialPageRoute(builder: (context) => page);
  }

  // * Do this Instead
  static pushTo(context, page) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }
}