import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';

import '../../models/model_place_clothes_recommend.dart';

class RecommendPlaceDetail extends StatelessWidget {
  final int index;

  RecommendPlaceDetail({Key? key, required this.index}) : super(key: key);

  Future<void> _sendDataToServer(String id, String placeName, String placeLocation, List<String> outfitUrls) async {
    var url = Uri.parse('http://34.170.39.54:6000/choose');
    Map<String, dynamic> data = {
      'id' : id,
      'placeName': placeName,
      'placeLocation': placeLocation,
      'outfitUrls': outfitUrls,
    };
    var body = json.encode(data);
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body,);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send data value to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    var placeClothesRecommendModel = Provider.of<PlaceClothesRecommendModel>(context);
    var recommendationSets = placeClothesRecommendModel.recommendationSets;

    var placeName = recommendationSets[index]['placeName'];
    var placeLocation = recommendationSets[index]['placeLocation'];
    var placeDescription = recommendationSets[index]['placeDescription'];
    var outfitUrls = recommendationSets[index]['outfitUrls'];
    var descriptions = ['Outer', 'Top', 'Bottom', 'Shoes', 'Acc'];

    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text('장소 추천'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  '장소 위치: $placeLocation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  '장소 이름: $placeName',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  '장소 설명: $placeDescription',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                AppBar(
                                  backgroundColor: const Color.fromARGB(255, 6, 67, 117),
                                  title: Text('Attire recommendations'),
                                  actions: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    for (int i = 0; i < outfitUrls.length; i++)
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Image.network(
                                              outfitUrls[i],
                                              fit: BoxFit.cover,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                descriptions[i],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('View suggested outfits'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // TODO: Implement Confirm button functionality
                      await _sendDataToServer(
                        id!,
                        placeName,
                        placeLocation,
                        outfitUrls,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Confirm!'),
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                            (route) => false,
                      );
                    },
                    child: Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }
}
