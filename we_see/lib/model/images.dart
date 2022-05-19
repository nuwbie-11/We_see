import 'dart:io';

import 'package:gallery_saver/gallery_saver.dart';

class Images{
  late File image;

  late dynamic path;

  Images({
    required path
  });

  Future<bool?> save_images(image) {
    return GallerySaver.saveImage(image.path);
  }

}