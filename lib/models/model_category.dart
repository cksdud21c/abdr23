// category.dart
import 'package:untitled/models/model_clothing_item.dart';

class Category {
  String name;
  late List<ClothingItem> clothingItems; //late : 값을 나중에 할당 받을 것임을 나타냄.
  Category({required this.name, required this.clothingItems}); //Category 인스턴스 생성시 name,clothingItems에 값 할당
}