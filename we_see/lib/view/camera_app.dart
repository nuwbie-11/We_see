import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

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
  List _recognition = [];
  bool _busy = false;

  loadMnet() async {
    await Tflite.loadModel(
        model: "assets/0.21DR-0.0001LR-VanillaMnetSGDOPT.tflite",
        labels: "assets/Mnetlabels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  doMnet(String imagePath) async {
    String resizedImage = await saveResizedImageTemporarily(imagePath);

    var recognitions = await Tflite.runModelOnImage(
      path: resizedImage,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.1,
    );

    setState(() {
      _recognition = recognitions!;
    });
  }

  // This method takes in a Uint8List of bytes representing the captured image
  Future<Uint8List> resizeImage(Uint8List imageBytes) async {
    img.Image? oriImage = img.decodeJpg(imageBytes);
    // img.Image resizedImage = img.copyResize(oriImage!, height: 256, width: 256);

    img.Image resizedImage = img.copyResizeCropSquare(oriImage!, 256);

    // Encode the resized image to a Uint8List and return it
    return Uint8List.fromList(img.encodePng(resizedImage));
  }

  // This method takes in a String file path representing the captured image
  Future<String> saveResizedImageTemporarily(String imagePath) async {
    // Read the image file as bytes using the File class
    Uint8List imageBytes = await File(imagePath).readAsBytes();

    // Decode and resize the image as shown in the previous answer
    var resizedImage = await resizeImage(imageBytes);

    // Get the system's temporary directory using the Directory.systemTemp method
    Directory tempDir = Directory.systemTemp;

    // Generate a unique file name for the image using the current timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = 'resized_image_$timestamp.png';

    // Create a new file in the temporary directory with the generated file name
    File resizedImageFile = File('${tempDir.path}/$fileName');

    // Write the resized image bytes to the file
    await resizedImageFile.writeAsBytes(resizedImage);

    // Return the file path of the saved image
    return resizedImageFile.path;
  }



  loadUnet() async {
    await Tflite.loadModel(
        model: "assets/myUNET_model-Dropout0.2-4Layer.tflite",
        labels: "assets/Unetlabels.txt");
  }

  Future recognizeImageBinary(File image) async {
    var imageBytes = await image.readAsBytes();

    // var input = await resizeImage(imageBytes);
    // print("IMAGE RESIZED");
    var recognitions = await Tflite.runSegmentationOnBinary(
      binary: imageBytes,
      outputType: 'png',
    );
    setState(() {
      _recognition = recognitions!;
    });

  }
  doUnet(String imagePath) async {
    String resizedImage = await saveResizedImageTemporarily(imagePath);

    var recognitions = await Tflite.runSegmentationOnImage(
      path: resizedImage,
      outputType: "png",
      imageMean: 0,
      imageStd: 255,
      asynch: true,
    );

    setState(() {
      _recognition = recognitions!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMnet();
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
    super.dispose();
    cam.onDispose();
    await Tflite.close();
    WidgetsBinding.instance.removeObserver(this);
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

                                    await doMnet(imagePath);

                                    // print("Output : $_recognition");

                                    BridgeView.pushTo(
                                        context,
                                        DisplayPictureScreen(
                                          image: File(imagePath),
                                          result: _recognition,
                                          type: '0',
                                        ));
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
