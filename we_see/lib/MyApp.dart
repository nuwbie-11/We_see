import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_see/MySplash.dart';
import 'package:we_see/views/MyCameraApp.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool started = false;


  List<CameraDescription> _cameras = <CameraDescription>[];

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  Future<void> _checkCamera() async {
    try {
        WidgetsFlutterBinding.ensureInitialized();
        _cameras = await availableCameras();
        // print(_cameras);
      } on CameraException catch (e) {
        _logError(e.code, e.description);
      }
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
    // TODO: implement initState

    
    checkPref();
    _checkCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: started ?
      const MyCameraApp() 
      : const MySplashScreen(),
    );
  }
}

