import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_input_emotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/model_place_clothes_recommend.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HopeEmotionScreen extends StatelessWidget {
  HopeEmotionScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => InputEmotionModel(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 6, 67, 117),
            title: Text('감정 입력 : 희망 감정'),
          ),
          endDrawer : SafeArea(
            child:
              Menu(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                HopeEmotionInput(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                NextButton(),
              ],
             ),
            ),
          bottomNavigationBar: Bottombar(),
          ),
    );
  }
}

class HopeEmotionInput extends StatelessWidget {
  final _controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var hemotion = Provider.of<InputEmotionModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          _controller.text = ''; // clear prefixText
        },
        child: TextFormField(
          onChanged: (emotion) {
            hemotion.setEmotion(emotion); // update variable with user input
          },
          keyboardType: TextInputType.text,
          controller: _controller,
          decoration: InputDecoration(
            labelText: '희망하는 감정을 입력해주세요',
            hintText: '평온한 분위기를 느끼고 싶어.',
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final hemotion = Provider.of<InputEmotionModel>(context, listen: false);
    final placeClothesRecommendModel = Provider.of<PlaceClothesRecommendModel>(context, listen: false);
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    return TextButton(
      onPressed: () async {
        if (hemotion.emotion.isNotEmpty) {
          await fetchRecommendations(hemotion.emotion, id!,placeClothesRecommendModel);
        }
        Navigator.of(context).pushNamed("/screen_recommend_place");
      },
      child: Text('NEXT'),
    );
  }

  Future<void> fetchRecommendations(String emotion, String id, PlaceClothesRecommendModel placeClothesRecommendModel) async {
    try {
      var response = await sendHopeEmotionToServer(emotion, id);
      List<Map<String, dynamic>> recommendationSets = [];

      for (var i = 0; i < 3; i++) {
        var placeName = response['placeName$i'];
        var placeLocation = response['placeLocation$i'];
        var placeDescription = response['placeDescription$i'];
        List<String> outfitUrls = [];

        for (var j = 0; j < 5; j++) {
          var outfitUrl = response['outfitUrls$i$j'];
          outfitUrls.add(outfitUrl);
        }

        var recommendationSet = {
          'placeName': placeName,
          'placeLocation': placeLocation,
          'placeDescription': placeDescription,
          'outfitUrls': outfitUrls,
        };

        recommendationSets.add(recommendationSet);
      }

      placeClothesRecommendModel.setRecommendationSets(recommendationSets);
    } catch (error) {
      print('Failed to fetch recommendations: $error');
    }
  }
}

//<Map<String, dynamic>> :  반환형은 Map이며, key는 String 타입, value는 아무 타입이나 올 수 있다.
Future <Map<String, dynamic>> sendHopeEmotionToServer(String he, String id) async {
  var url = Uri.parse('http://34.170.39.54:6000/he');
  var data = {'he': he, 'id': id};
  var body = json.encode(data);
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to send hope emotion value to the server');
  }
}
