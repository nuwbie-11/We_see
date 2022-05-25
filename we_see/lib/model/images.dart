import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class Images{

  late String filePath;


  Images(){
    filePath = "";
    init_root();
    
  }

  set setFilePath(String filePath){
    this.filePath = filePath;
    // print(filePath);
  }

  Future<String> init_root() async {
    Directory _root = await getTemporaryDirectory();
    String dirPath = "${_root.path}/we_see";
    await Directory(dirPath).create(recursive: true);
    String filePath = "$dirPath/temp.jpg";
    setFilePath = filePath;
    return filePath;  
  }

}