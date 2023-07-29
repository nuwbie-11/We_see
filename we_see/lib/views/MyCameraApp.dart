import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:we_see/Logs.dart';
import 'package:we_see/Helper/bridge.dart';
import 'package:we_see/Helper/Camera.dart';
import 'package:we_see/Helper/Classifier.dart';
import 'package:we_see/Views/display.dart';

class MyCameraApp extends StatefulWidget {
  const MyCameraApp({Key? key});

  @override
  State<MyCameraApp> createState() => _MyCameraAppState();
}

class _MyCameraAppState extends State<MyCameraApp>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final ClassificationModel classifi = ClassificationModel();


  bool _isInitialized = false;
  Camera cam = Camera();
  CameraController? controller;
  XFile? imageFile;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;

  List<dynamic> response = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initilizeCam();
    if (controller!=null) {
      setState(() {
        _isInitialized = true;
        controller!.initialize();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initilizeCam();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ambil Gambar")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color:
                      controller != null && controller!.value.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.grey,
                  width: 3.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initilizeCam() async {
    final camController = await cam.initializeCameraController(
        const CameraDescription(
            name: '0',
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 180));


    

    camController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (camController.value.hasError) {
        showInSnackBar('Camera error ${camController.value.errorDescription}');
      }
    });

    try {
      await camController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }


    if (camController.value.isInitialized) {
      setState(() {
        controller = camController;
        // Controller Should be initialized first to set FlashMode
        camController.setFlashMode(FlashMode.torch);
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  Future<void> onViewFinderTap(
      TapDownDetails details, BoxConstraints constraints) async {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);

    // onTakePicture();

    // File images = File(await cam.onPictureTake(controller!));
    // print("FEEDBACK");
    // print(images.path);
    // dynamic result = classifi.predictImage(images.path);
    // BridgeView.pushTo(context, DisplayPictureScreen(image: images, result: result));
    // cameraController.takePicture().then((XFile? file) {
    //   if (mounted) {
    //     setState(() {
    //       imageFile = file;
    //       print("Image captured");
    //     });
    //     if (file != null) {
    //       showInSnackBar('Picture saved to ${file.path}');
    //     }
    //   }
    // });
  }

  void onTakePicture() async {
    if (controller == null) {
      return;
    }

    final ClassificationModel classifier = ClassificationModel();
    final CameraController cameraController = controller!;


    // Takes Picture
    String imagePath = await cam.onPictureTake(cameraController);
    if (imagePath != null){
      setState(() {
        imageFile = XFile(imagePath);
      });
    }

    // Predict Image
    List<dynamic> feed = await classifier.predictImage(imageFile!.path);
    if (feed != null) {
      setState(() {
        response = feed;
      });
    }


    print('Result Forked : $response');

    // Pass Captured Image to DisplayScreen
    BridgeView.pushTo(
        context,
        DisplayPictureScreen(
          image: File(imageFile!.path),
          result: response,
        ));
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    Log().logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return CameraPreview(
        controller!,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onTap: () => onTakePicture(),
            // onTapDown: (TapDownDetails details) =>
            //     onViewFinderTap(details, constraints),
          );
        }),
      );
    }
  }
}
