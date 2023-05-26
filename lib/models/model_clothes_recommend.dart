import 'package:flutter/material.dart';

class ClothesRecommendModel extends ChangeNotifier {
  List<List<String>> _recommendationSets = [];
  List<List<String>> get recommendationSets => _recommendationSets;

  void setRecommendationSets(List<List<String>> sets) {
    if (sets.length == 3 && sets.every((set) => set.length == 5)) {
      _recommendationSets = sets;
      notifyListeners();
    }
  }
}
