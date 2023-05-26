import 'package:flutter/material.dart';

class PlaceClothesRecommendModel extends ChangeNotifier {
  List<Map<String, dynamic>> _recommendationSets = [];

  List<Map<String, dynamic>> get recommendationSets => _recommendationSets;

  void setRecommendationSets(List<Map<String, dynamic>> sets) {
    if (sets.length == 3) {
      _recommendationSets = sets;
      notifyListeners();
    }
  }
}
