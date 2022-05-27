import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/view/camera_app.dart';

class DisplayPictureScreen extends StatelessWidget {
  final File imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Column(
          children: [
            Image.file(imagePath),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    // imagePath.delete();
                    // Navigator.pushReplacement(context,
                    //     BridgeView.routeTo(context, const CameraApp()));
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
