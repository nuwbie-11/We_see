import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/presenter/image_presenter.dart';
import 'package:we_see/view/camera_app.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  ImagePresenter imgP = ImagePresenter();
  dynamic response = [];


  void getContent() async {
    var tempRes = await imgP.getInsight();
    setState(() {
      
      response = tempRes;
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
        appBar: AppBar(title: const Text('Display the Picture')),

        body: response.isEmpty ? const CircularProgressIndicator() :Column(
          children: [
            Image.file(widget.imagePath),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    
                    BridgeView.pushTo(context, const CameraApp());
                  },
                  child: const Text("OK"),
                ),
              ),
            )
          ],
        ));
  }
}
