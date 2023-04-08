import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/presenter/camera_presenter.dart';
import 'package:we_see/presenter/image_presenter.dart';
import 'package:we_see/presenter/tts_presenter.dart';
import 'package:we_see/view/display.dart';
import 'package:tflite/tflite.dart';

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

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/forskripsi.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    WidgetsBinding.instance.addObserver(this);
    var tempVar = cam.initCam();

    setState(() {
      _isInit = tempVar;
    });

    _initializeControllerFuture = cam.getInitializeControllerFuture;
    _controller = cam.getController;
    _controller.setFlashMode(FlashMode.torch);
  }

  @override
  Future<void> dispose() async {
    cam.onDispose();
    await Tflite.close();
    WidgetsBinding.instance.removeObserver(this);
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
      body: _isInit
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (_, snapshot) =>
                  (snapshot.connectionState == ConnectionState.done)
                      ? Stack(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    XFile imageFile =
                                        await _controller.takePicture();
                                    String imagePath = imageFile.path;

                                    print(imagePath);

                                    var output = await Tflite.runModelOnImage(
                                      path: imagePath,
                                      imageMean: 0.0,
                                      imageStd: 255.0,
                                      numResults: 2,
                                      threshold: 0.1,
                                    );

                                    String predictedLabel = output![0]['label'];
                                    double confidence = output[0]['confidence'];

                                    print(
                                        "Predicted Label : $predictedLabel with $confidence %");

                                    // BridgeView.pushTo(context,
                                    //     DisplayPictureScreen(image: bytes!));
                                  },
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        AppBar().preferredSize.height * 2,
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
                        ))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
