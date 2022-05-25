import 'dart:io';

import 'package:camera/camera.dart';
import 'package:we_see/model/images.dart';

class ImagePresenter {
  // late String _filePath;
  final imgModel = Images();
  CameraController? _controller;

  ImagePresenter({required controller}){
    _controller = controller;
  }

  Future<File?> takePicture() async {
    String filePath = imgModel.filePath;

    try {
      XFile img = await _controller!.takePicture();
      print(filePath);
      img.saveTo(filePath);
    } catch (e) {
      return null;
    }

    return File(filePath);
  }
}