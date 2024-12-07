import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerProvider extends ChangeNotifier {
  ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isLoading = false;
  XFile? get imageFile => _imageFile;


  bool get isLoading => _isLoading;


  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  void clearImage() {
    _imageFile = null; // Reset the image
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> pickImage() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = pickedFile;
        notifyListeners();
      } else {
        print("No image selected.");
      }
    } else {
      print("Storage permission denied.");
    }
  }


}
