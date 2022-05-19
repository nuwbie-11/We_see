import 'package:camera/camera.dart';

class ImagePresenter {
  
  
  static XFile Capture({controller}){
    return controller.takePicture();
  }
}