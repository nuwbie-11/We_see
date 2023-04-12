import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:we_see/model/images.dart';
import 'package:we_see/view/display.dart';

class ImagePresenter {
  Future<File?> takePicture(_controller) async {
    Images imgModel = Images();
    String filePath = await imgModel.getFilepath();
    
    try {
      XFile img = await _controller!.takePicture();
      
      // File(img.path).delete();
      img.saveTo(filePath);
    } catch (e) {
      return null;
    }
    return File(filePath);
  }

  // MaterialPageRoute displayImage(File filePath, context) {
  //   return MaterialPageRoute(
  //       builder: (context) => DisplayPictureScreen(image: filePath));
  // }

  getInsight(File img) {
    Images imgModel = Images();
    return imgModel.predict(img) == null ? [] : imgModel.predict(img);
  }
}
