import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_input_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../../models/model_clothes_recommend.dart';

class InputPlaceScreen extends StatelessWidget {
  InputPlaceScreen({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InputPlaceModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 6, 67, 117),
          title: Text('장소 입력'),
        ),
        endDrawer: SafeArea(
          child: Menu(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              InputPlace(),
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

class InputPlace extends StatefulWidget {
  @override
  _InputPlaceState createState() => _InputPlaceState();
}

class _InputPlaceState extends State<InputPlace> {
  final TextEditingController _controller = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = GlobalKey();

  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    var hplace = Provider.of<InputPlaceModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          _controller.text = ''; // clear prefixText
        },
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: hplace.district,
              onChanged: (value) {
                hplace.setSelectedDistrict(value!); // update selected district
              },
              items: ['성동구', '광진구', '동대문구', '중구', '종로구', '용산구', '서대문구', '마포구', '강서구', '양천구', '강동구', '송파구', '강남구', '서초구', '도봉구', '노원구', '은평구' ,'성북구', '관악구', '동작구', '금천구', '구로구', '영등포구', '광진구'].map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select District',
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: hplace.category,
              onChanged: (value) {
                hplace.setSelectedCategory(value!); // update selected category
              },
              items: ['관광지','문화시설', '레포츠', '음식점'].map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Category',
              ),
            ),
            SizedBox(height: 10),
            AutoCompleteTextField(
              key: autoCompleteKey,
              controller: _controller,
              clearOnSubmit: false,
              suggestions: suggestions,
              decoration: InputDecoration(
                labelText: 'Enter your destination',
                hintText: '세종대학교.',
              ),
              itemFilter: (item, query) {
                return item.toLowerCase().startsWith(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return a.compareTo(b);
              },
              itemSubmitted: (item) async {
                _controller.text = item; // set selected place name
                hplace.setPlace(item); // update variable with user input

                await fetchSuggestions(hplace.district,hplace.category,item); // fetch suggestions from server
              },
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchSuggestions(String place, String district, String category) async {
    var url = Uri.parse('http://34.66.37.198/suggest'); // change the server URL to the correct endpoint for fetching suggestions
    var data = {'district': district, 'category' : category, 'place': place};
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      setState(() {
        suggestions = List<String>.from(responseData);
      });
    }
  }
}

class NextButton extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var hplace = Provider.of<InputPlaceModel>(context, listen: false);
    var clothesRecommendModel =
    Provider.of<ClothesRecommendModel>(context, listen: false);

    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id = user!.email;

    return TextButton(
      onPressed: () async {
        if (hplace.place.isNotEmpty) {
          List<List<String>> recommendationSets = await sendPlaceNameValueToServer(
            id!,
            hplace.place,
            hplace.district,
            hplace.category,
          );
          if (recommendationSets.isNotEmpty) {
            clothesRecommendModel.setRecommendationSets(recommendationSets);
            Navigator.of(context).pushNamed('/screen_recommend_clothes');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('일치하는 장소가 없어요'),
              ),
            );
          }
        }
      },
      child: Text('NEXT'),
    );
  }
}

Future<List<List<String>>> sendPlaceNameValueToServer(
    String id, String pn, String d, String c) async {
  var url = Uri.parse('http://34.170.39.54:6000/spacename');
  var data = {'ID': id, 'place': pn, 'district': d, 'Category': c};
  var body = json.encode(data);
  var response =
  await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
    List<List<String>> recommendationSets = [];
    for (dynamic set in responseData) {
      List<String> urls = List<String>.from(set);
      recommendationSets.add(urls);
    }
    return recommendationSets;
  } else {
    throw Exception('Failed to send place name to server');
  }
}
