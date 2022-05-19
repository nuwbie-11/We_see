

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:we_see/view/camera_app.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final myCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CameraApp(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: myCamera,
      ),
    ),
  );
}

