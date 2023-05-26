import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/models/model_category.dart';
import 'package:untitled/screens/closet_components/flask_client.dart';
import 'package:untitled/models/model_clothing_item.dart';

class ClosetController {
  FlaskClient _flaskClient = FlaskClient();

  List<Category> categories = [
    Category(name: 'All', clothingItems: []),
    Category(name: 'Outer', clothingItems: []),
    Category(name: 'Top', clothingItems: []),
    Category(name: 'Bottom', clothingItems: []),
    Category(name: 'Shoes', clothingItems: []),
    Category(name: 'Acc', clothingItems: []),
    Category(name: 'NoLabel', clothingItems: []),
  ];

  Future<List<ClothingItem>> fetchClothingItems(String category) async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;

    List<String> itemUrls = await _flaskClient.getClothingItems(category,id!);
    return itemUrls.map((url) {
      return ClothingItem(
        imageUrl: url,
      );
    }).toList();
  }

  Category getCategoryByName(String categoryName) {
    return categories.firstWhere((category) => category.name == categoryName);
  }//category.name과 categoryName이 일치하면 해당 category객체 반환.
//즉, 카테고리 목록에서 특정 카테고리를 찾으려고 만든 함수.
}

