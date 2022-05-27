import 'package:flutter/material.dart';

class BridgeView {
  static routeTo(context, page) {
    return MaterialPageRoute(builder: (context) => page);
  }

  static pushTo(context,page){
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }
}
