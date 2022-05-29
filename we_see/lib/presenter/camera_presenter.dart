import 'dart:io';

import 'package:camera/camera.dart';
import 'package:we_see/model/images.dart';

class CameraPresenter{
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final camModel = Images(); 
  

  CameraPresenter({required activeCam}){
    _controller = CameraController(activeCam, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }
  
  Future<void> get getInitializeControllerFuture{
    return _initializeControllerFuture;
  }

  CameraController get getController{
    return _controller;
  }

  set setInitializeControllerFuture(Future<void> context){
    this._initializeControllerFuture =context;
  }

  set setController(CameraController context){
    this._controller = context;
  }


  Future<List> getCam() async{
    return availableCameras();
  }

  Future<void> initCam() async {
    
    var cameras = await availableCameras();

    _controller = CameraController(cameras[0], ResolutionPreset.max);
    setController=_controller;

    var initializeControllerFuture =  _controller.initialize();
    setInitializeControllerFuture =  initializeControllerFuture;
  }


  Future<File?> takePicture() async {
    String filePath = camModel.filePath;

    try {
      XFile img = await _controller.takePicture();
      img.saveTo(filePath);
    } catch (e) {
      return null;
    }

    return File(filePath);
  }

  Future<void> onDispose(){
    return _controller.dispose();
  }

}