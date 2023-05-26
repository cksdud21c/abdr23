// model/model_input_emotion.dart
import 'package:flutter/material.dart';

class InputEmotionModel extends ChangeNotifier {
  String emotion = "";
  void setEmotion(String emotion) {
    this.emotion = emotion;
    notifyListeners();
  }
}