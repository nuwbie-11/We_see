import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:we_see/model/images.dart';

class CameraPresenter {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final camModel = Images();

  CameraPresenter();

  initCam() {
    List<CameraDescription> _usedCamera = [
      const CameraDescription(
          name: '0',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 90)
    ];
    _controller = CameraController(_usedCamera[0], ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
    return true;
  }

  Future<void> get getInitializeControllerFuture {
    return _initializeControllerFuture;
  }

  CameraController get getController {
    return _controller;
  }

  set setInitializeControllerFuture(Future<void> context) {
    this._initializeControllerFuture = context;
  }

  set setController(CameraController context) {
    this._controller = context;
  }

  setFlashmode() async {
    await _controller.setFlashMode(FlashMode.always);
  }

  Future<List> getCam() async {
    return availableCameras();
  }

  Future<File?> takePicture() async {
    String filePath = camModel.filePath;

    try {
      XFile img = await _controller.takePicture();

      Uint8List imgBytes = await img.readAsBytes();

      img.saveTo(filePath);
    } catch (e) {
      return null;
    }

    return File(filePath);
  }

  Future<void> onDispose() {
    return _controller.dispose();
  }
}
