import 'package:tflite/tflite.dart';


class ClassificationModel{
  final _modelPath = "assets/1x128+1x32-0.2Dr-0.0001LR-Mnetv2-glblplb2d.tflite";

  get modelPath => _modelPath;

  ClassificationModel(){
    inittializeModel();
  }
  
  void inittializeModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: modelPath,
        labels: "assets/Mnetlabels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  Future<dynamic> predictImage(String imagePath) async {
    var result = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.5,
    );
    print('Result : $result');
    return result;
  }


}