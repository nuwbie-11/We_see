import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_see/controller/Bridge.dart';
import 'package:we_see/views/MyCameraApp.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File image;
  final List result;

  const DisplayPictureScreen({Key? key, required this.image, required this.result}) : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  dynamic response = [];

  void getContent() async {

    setState(() {
      response = widget.result;
    });
  }

  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: response == null || response.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          200,
                      width: MediaQuery.of(context).size.width,
                      child: Image.file(widget.image)),
                  Center(
                    child: Text(response.toString()),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          BridgeView.pushTo(context, const MyCameraApp());
                        },
                        child: const Text("OK"),
                      ),
                    ),
                  ),
                  
                ],
              ));
  }
}