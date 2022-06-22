import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/presenter/image_presenter.dart';
import 'package:we_see/view/camera_app.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File image;

  const DisplayPictureScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  ImagePresenter imgP = ImagePresenter();
  dynamic response = [];

  void getContent() async {
    var tempRes = await imgP.getInsight(widget.image);
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
                          BridgeView.pushTo(context, const CameraApp());
                        },
                        child: const Text("OK"),
                      ),
                    ),
                  ),
                  
                ],
              ));
  }
}
