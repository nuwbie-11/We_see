import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Images {
  late String filePath;

  set setFilePath(String filePath) {
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
    while (File(filePath).existsSync() == true) {
      // print("exist");
      i++;
      filePath = "$dirPath/temp$i.jpg";
    }
    setFilePath = filePath;
    return filePath;
  }

  predict(File img) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse("https://wisii.herokuapp.com/predict"));
    request.files.add(
      await http.MultipartFile.fromPath(
        'images',img.path,contentType: MediaType('application', 'jpeg')
      )
    );

    http.StreamedResponse res = await request.send();

    print(res.statusCode);
    var answer = (await res.stream.transform(utf8.decoder).join());
    return answer;
  }
}
