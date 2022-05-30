import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

class Conn {
  String url = "https://wisii.herokuapp.com/predict";

  Conn();

  http.Client getClient() {
    return http.Client();
  }

  // getResponse(File img) async {
  //   // var client = getClient();
  //   print(img);
  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       body: {'image':'base64Encode(img.readAsBytesSync())'}
  //     );
  //     print(response.statusCode);
  //     Map<String, dynamic> decoded = jsonDecode(response.body);
  //     print(decoded['response']);
  //     return decoded['response'];
  //   } catch (e) {
  //     print(e);
  //     return e;
  //   }
  // }

  // getResponse(File img) async {
  //   // final client = RetryClient(http.Client());
  //   // try {
  //   //   print(await client.read(Uri.parse(url)));
  //   // } finally {
  //   //   client.close();
  //   // }
  //   final request = http.MultipartRequest("POST", Uri.parse(url));
  //   final headers = {"Content-type": "application/json; charset=UTF-8"};

  //   // request.files.add(http.MultipartFile(
  //   //   'image',
  //   //   img.readAsBytes().asStream(),
  //   //   img.lengthSync(),
  //   // ));

  //   request.files.add(await http.MultipartFile.fromPath('images', img.path,contentType: MediaType('application', 'jpeg')));

  //   request.headers.addAll(headers);
  //   // request.headers.addAll("Content-Type", "application/json; charset=UTF-8");
  //   final response = await request.send();

  //   // http.Response res = await http.Response.fromStream(response);
  //   print(response.statusCode);
  //   // final resJson = jsonDecode(res.body);

  //   print(await response.stream.transform(utf8.decoder).join());
  // }

  
}
