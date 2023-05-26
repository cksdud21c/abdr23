// model/model_input_place.dart
import 'package:flutter/material.dart';

class InputPlaceModel extends ChangeNotifier {
  String place = "";
  String district ="성동구";
  String category ="음식점";

  void setPlace(String place) {
    this.place = place;
    notifyListeners();
  }

  void setSelectedDistrict(String district) {
    this.district = district;
    notifyListeners();
  }
  void setSelectedCategory(String category) {
    this.category = category;
    notifyListeners();
  }
}