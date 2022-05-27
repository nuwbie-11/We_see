
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/view/camera_app.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({ Key? key }) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {

  void setStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('started', true);
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("This is Getting Start Page"),
          ElevatedButton(onPressed: (){
            setStarted();
            BridgeView.pushTo(context, CameraApp());
          }, child: Text("OK"))
        ],
      ),
    );
  }
}