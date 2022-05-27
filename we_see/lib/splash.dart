import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_see/getting_start.dart';
import 'package:we_see/view/camera_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final FlutterTts flutterTts = FlutterTts();
  // final prefs = SharedPreferences.getInstance();
  bool started = false;

  speak() async{
    print("Speak Called");
    await flutterTts.setLanguage("id_ID");
    await flutterTts.setPitch(1);
    await flutterTts.speak("Haloo, Kami We see ingin membantu anda untuk mengenali Nominal pada Uang");
    await flutterTts.speak("Caranya. 1. Lipat uang menjadi 2 bagian");
  }

  void checkPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if (prefs.getBool('started') == null) {
      setState(() {
        started = false;
      });
    } else {
      setState(() {
        started = true;
      });
    }

  }
  
  @override
  void initState() {
    super.initState();
    speak();
    checkPref();
    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _a = true;
      });
    });
    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _b = true;
      });
    });
    Timer(Duration(milliseconds: 1300), () {
      setState(() {
        _c = true;
      });
    });
    Timer(Duration(milliseconds: 1700), () {
      setState(() {
        _e = true;
      });
    });
    Timer(Duration(milliseconds: 3400), () {
      setState(() {
        _d = true;
      });
    });
    Timer(Duration(milliseconds: 3850), () {
      
      setState(() {
        
        Navigator.of(context).pushReplacement(
          ThisIsFadeRoute(
            page: started? CameraApp():GettingStarted(),
            // route: ThirdPage(),
          ),
        );
      });
    });
  }

  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              
              duration: Duration(milliseconds: _d ? 900 : 2500),
              curve: _d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
              height: _d
                  ? 0
                  : _a
                      ? _h / 2
                      : 20,
              width: 20,
              // color: Colors.deepPurpleAccent,
            ),
            AnimatedContainer(
              
              duration: Duration(
                  seconds: _d
                      ? 1
                      : _c
                          ? 2
                          : 0),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d
                  ? _h
                  : _c
                      ? 80
                      : 20,
              width: _d
                  ? _w
                  : _c
                      ? 200
                      : 20,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/logo.jpg"),
                      ),
                  // color: _b ? Colors.white : Colors.transparent,
                  // shape: _c? BoxShape.rectangle : BoxShape.circle,
                  ),
                  
            ),
          ],
        ),
      )
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget page;

  ThisIsFadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: page,
          ),
        );
}