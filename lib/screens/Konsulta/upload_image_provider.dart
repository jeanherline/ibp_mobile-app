// upload_image_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';

class UploadImageProvider with ChangeNotifier {
  File? _imageFile;

  File? get imageFile => _imageFile;

  void setImage(File? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }
}
