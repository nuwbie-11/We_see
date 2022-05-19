import 'package:camera/camera.dart';

class Cameras{

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final CameraDescription camera;

  Cameras({required this.camera});


  CameraController get controller {
    return this._controller;
  }

  CameraController init_cam() {
    _controller = CameraController(
      this.camera,
      ResolutionPreset.medium

    );

    return _controller;
    
  }

  Future<void> get initializeControllerFuture{
    this._initializeControllerFuture = this.init_cam().initialize();

    return this._initializeControllerFuture;
  }
}