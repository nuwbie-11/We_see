import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/presenter/camera_presenter.dart';
import 'package:we_see/presenter/image_presenter.dart';
import 'package:we_see/presenter/tts_presenter.dart';
import 'package:we_see/view/display.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {

  TtsPresenter tts = TtsPresenter();
  CameraPresenter cam = CameraPresenter();
  late Future<void> _initializeControllerFuture;
  late CameraController _controller;
  bool _isInit = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    var tempVar = cam.initCam();

    setState(() {
      _isInit = tempVar;
    });


    _initializeControllerFuture = cam.getInitializeControllerFuture;
    _controller = cam.getController;
    _controller.setFlashMode(FlashMode.torch);
  }

  @override
  void dispose() {
    cam.onDispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {

        cam.onDispose();
        // exit(0);

    }
    if (state == AppLifecycleState.resumed) {
      cam.initCam();
      _controller = cam.getController;
    }
  }


  @override
  Widget build(BuildContext context) {
    final ImagePresenter imgP = ImagePresenter();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambil Gambar"),
      ),
      body: _isInit ? FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (_, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? Stack(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final filepath =
                                    await imgP.takePicture(_controller);

                                BridgeView.pushTo(context,
                                    DisplayPictureScreen(image: filepath!));
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height*2,
                                width: MediaQuery.of(context).size.width,
                                child: CameraPreview(cam.getController),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 5,
                            )),
                          ],
                        ),
                      ],
                    )
                  : const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    )) :
          const
          Center(child:CircularProgressIndicator())
          ,
    );
  }
}
