import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_see/presenter/bridge_view.dart';
import 'package:we_see/presenter/image_presenter.dart';
import 'package:we_see/view/camera_app.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File image;
  final dynamic result;
  final String type;

  const DisplayPictureScreen(
      {Key? key, required this.image, required this.result, required this.type})
      : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  ImagePresenter imgP = ImagePresenter();
  dynamic response = [];

  void getContent() async {
    // var tempRes = await imgP.getInsight(widget.image);
    // print(tempRes);
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
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.type == '1'
            ? Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          200,
                      width: MediaQuery.of(context).size.width,
                      child: Image.memory(widget.result, fit: BoxFit.fill,)),
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
              )
            : response == null || response.isEmpty
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
                        child: Column(
                          children: [
                            for (var i =0;i < response.length;i++)
                              Text("Prediksi "+response[i]["label"].toString()+" dengan keyakinan "+(response[i]["confidence"]*100 ).toStringAsFixed(2))
                            
                          ],
                        ),
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
