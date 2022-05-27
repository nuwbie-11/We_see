import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class Images{

  late String filePath;


  set setFilePath(String filePath){
    this.filePath = filePath;
    // print(filePath);
  }

  Future<String> getFilepath() async {
    Directory _root = await getTemporaryDirectory();
    String dirPath = "${_root.path}/we_see";
    int i = 0;
    await Directory(dirPath).create(recursive: true);
    String filePath = "$dirPath/temp$i.jpg";
    // if (File(filePath).existsSync() == true ) {
    //   File(filePath).delete(recursive: true);
    // }
    while (File(filePath).existsSync() == true ) {
      // print("exist");
      i++;
      filePath = "$dirPath/temp$i.jpg";
    }
    setFilePath = filePath;
    return filePath;  
  }

}