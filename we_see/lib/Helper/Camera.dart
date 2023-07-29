import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:we_see/Helper/Images.dart';

class Camera with ChangeNotifier {


  bool enableAudio = true;
  ImageHelper helper = ImageHelper();


  List<CameraDescription> _availableCamera = [];
  List get availableCamera => _availableCamera;

  XFile? imageFile;

  // final Classifier classifier = Classifier();



  Future<CameraController> initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    // cameraController.initialize();
    
    return cameraController;
  }

  Future<String> onPictureTake(CameraController usedControler) async {
    
    XFile image = await usedControler.takePicture();
  
  
    // decodeImage(imageFile!.path);
    return helper.saveResizedImageTemporarily(image.path);
  }


}
