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
  List<CameraDescription> _usedCamera = [
    const CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 90)
  ];
  TtsPresenter tts = TtsPresenter();
  late CameraPresenter cam;
  late Future<void> _initializeControllerFuture;

  void upCam() async {
    final cameras = await availableCameras();

    setState(() {
      _usedCamera = cameras;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    upCam();
    cam = CameraPresenter(activeCam: _usedCamera[0]);
    _initializeControllerFuture = cam.getInitializeControllerFuture;
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
      Timer(const Duration(seconds: 10), () {
        cam.onDispose();
        exit(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImagePresenter imgP = ImagePresenter();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambil Gambar"),
      ),
      body: FutureBuilder<void>(
          future: cam.getInitializeControllerFuture,
          builder: (_, snapshot) => (snapshot.connectionState ==
                  ConnectionState.done)
              ? Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height /
                              cam.getController.value.aspectRatio,
                          width: MediaQuery.of(context).size.width,
                          child: CameraPreview(cam.getController),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        )),
                        Row(children: [
                          FloatingActionButton(
                            onPressed: () async {
                              final filepath =
                                  await imgP.takePicture(cam.getController);
                              
                              BridgeView.pushTo(context,
                                  DisplayPictureScreen(image: filepath!));
                            },
                            child: const Icon(Icons.camera_alt),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                tts.introduce();
                              },
                              child: const Text("Cara Pemakaian"))
                        ])
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
                )),
    );
  }
}
