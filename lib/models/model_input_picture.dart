// model/model_input_emotion.dart
import 'package:flutter/material.dart';
import 'dart:io';

class InputPictureModel extends ChangeNotifier {
  File? picture;

  void setPicture(File? picture) {
    this.picture = picture;
    notifyListeners();
  }
}