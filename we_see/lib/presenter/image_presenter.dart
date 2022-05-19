import 'package:camera/camera.dart';

class ImagePresenter {
  
  
  static Future<XFile> capture({controller}){
    var img = controller.takePicture();

    return img;
  }
}