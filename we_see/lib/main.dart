import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_see/view/camera_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late File imageFile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraApp(),
    );
  }
}