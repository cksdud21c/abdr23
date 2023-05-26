import 'dart:convert';
import 'package:http/http.dart' as http;

class FlaskClient {
  Future<List<String>> getClothingItems(String category, String id) async {
    var url = Uri.parse('http://34.170.39.54:6000/closet');
    var data = {'id': id,'category': category};
    var body = json.encode(data);
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<String> itemUrls = List<String>.from(responseData['imagelist']);
      return itemUrls;
    } else {
      throw Exception('Failed to get clothing items from the server');
    }
  }
}





