import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:we_see/presenter/camera_presenter.dart';
import 'package:we_see/presenter/image_presenter.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver{
  List<CameraDescription> _usedCamera = [CameraDescription(name: '0', lensDirection: CameraLensDirection.back,  sensorOrientation: 90)];
  late CameraPresenter cam ;
  late Future<void> _initializeControllerFuture;
  



  void upCam() async {
    final cameras = await availableCameras();
    // print(cameras);

    setState(() {
      _usedCamera = cameras;
      print(_usedCamera);
      
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
    // TODO: implement dispose
    cam.onDispose();
    print("cam Disposed");
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      cam.onDispose();
      exit(0);
    }

  }
  

  @override
  Widget build(BuildContext context) {
    final ImagePresenter imgP = ImagePresenter(controller: cam.getController);
    return Scaffold(
      body: FutureBuilder<void>(
          future:cam.getInitializeControllerFuture,
          builder: (_, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / cam.getController.value.aspectRatio +50,
                            width: MediaQuery.of(context).size.width,
                            child: CameraPreview(cam.getController),
                          ),
                          Padding(padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          )),
                          FloatingActionButton(
                            
                            onPressed: (){
                              // cam.takePicture();
                              imgP.takePicture();
                            },
                            child: const Icon(Icons.camera_alt),)
                        ],
                        
                      ),
                      // Text("data",)
                      // Container(),
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