import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_see/MyApp.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool started = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  Future<void> _setPref() async {
    // This Method is used to start Splash Screen Once
    final SharedPreferences prefs = await _prefs ;


    await prefs.setBool('started', started);
  }


  @override
  void initState() {
    // TODO: implement initState
    _setPref();
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icons.home, 
      nextScreen: const MyApp(),
      duration: 3000 ,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,);
  }
}