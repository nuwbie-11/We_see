import 'package:camera/camera.dart';

class Cameras{

  late CameraController _controller;
  late Future<void> initializeControllerFuture;
  final CameraDescription camera;

  Cameras({required this.camera});


  CameraController get controller {
    return _controller;
  }

  CameraController init_cam() {
    _controller = CameraController(
      this.camera,
      ResolutionPreset.max

    );

    return _controller;
    
  }
}