import 'dart:io';

import 'package:camera/camera.dart';
import 'package:we_see/model/images.dart';

class CameraPresenter{
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final camModel = Images(); 
  

  CameraPresenter({required activeCam}){
    //print("Called");
    this._controller = CameraController(activeCam, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    // setInitializeControllerFuture = _controller.initialize();
    // //print(_initializeControllerFuture);
  }
  
  Future<void> get getInitializeControllerFuture{
    // dynamic f = initCam();
    //print("from Getter");
    return _initializeControllerFuture;
  }

  CameraController get getController{
    // _controller = CameraController(cameras, ResolutionPreset.medium);
    //print("from getter");
    return _controller;
  }

  set setInitializeControllerFuture(Future<void> context){
    this._initializeControllerFuture =context;
    //print("From Setter");
    //print(_initializeControllerFuture);
  }

  set setController(CameraController context){
    this._controller = context;
    //print("from setter");
    //print(_controller);
  }


  Future<List> getCam() async{
    return availableCameras();
  }

  Future<void> initCam() async {
    
    var cameras = await availableCameras();
    //print(cameras);

    _controller = CameraController(cameras[0], ResolutionPreset.max);
    setController=_controller;

    var initializeControllerFuture =  _controller.initialize();
    setInitializeControllerFuture =  initializeControllerFuture;
    // await _initializeControllerFuture;
  }


  Future<File?> takePicture() async {
    String filePath = camModel.filePath;

    try {
      XFile img = await _controller.takePicture();
      print(filePath);
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