import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/presenter/tts_presenter.dart';
import 'package:we_see/view/camera_app.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  bool _a = false;
  TtsPresenter tts = TtsPresenter();
  bool isDone = false;

  void setStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('started', true);
  }

  void setDone () async {
    var tempDone = await tts.introduce();
    setState(() {
      isDone = tempDone;
    }); 
  }

  @override
  void initState() {
    super.initState();
    setDone();
    Timer(Duration(seconds: 8), () {
      setState(() {
        _a = true;
        setStarted();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: isDone
              ? ElevatedButton(
                  onPressed: () {
                    BridgeView.pushTo(context, const CameraApp());
                  },
                  child: const Text("Saya Paham"))
              : CircularProgressIndicator()),
    );
  }
}
