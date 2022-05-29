import 'dart:convert';

import 'package:http/http.dart' as http;

class Conn {
  String URL = "https://wisii.herokuapp.com/get";

  Conn();

  http.Client getClient(){
    return http.Client();
  }


  getResponse() async {
    // var client = getClient();
    try {
      var response = await http.post(
        Uri.parse(URL),
        body: {'name':'Data'}
      );
      print(response);
      Map<String, dynamic> decoded = jsonDecode(response.body);
      print(decoded['response']); 
      return decoded['response'];
    } catch (e) {
      print(e);
    }
  }
}