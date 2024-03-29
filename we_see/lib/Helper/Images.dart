import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageHelper{
  
  Future<Uint8List> resizeImage(Uint8List imageBytes) async {
    img.Image? oriImage = img.decodeJpg(imageBytes);
    // img.Image resizedImage = img.copyResize(oriImage!, height: 256, width: 256);

    img.Image resizedImage = img.copyResizeCropSquare(oriImage!, 224);

    // Encode the resized image to a Uint8List and return it
    return Uint8List.fromList(img.encodePng(resizedImage));
  }
  
  //  method takes in a String file path representing the captured image
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

  Uint8List normalizeUint8List(Uint8List originalList) {
    // Step 1: Find the minimum and maximum values in the original Uint8List.
    int min = originalList.reduce((curr, next) => curr < next ? curr : next);
    int max = originalList.reduce((curr, next) => curr > next ? curr : next);

    // Step 2: Map each value in the original Uint8List to the new range (0 to 255).
    List<int> normalizedValues = originalList.map((value) {
      double normalizedValue = (value - min) / (max - min) * 255;
      return normalizedValue.round();
    }).toList();

    // Return the Uint8List with the normalized values.
    return Uint8List.fromList(normalizedValues);
  }
}