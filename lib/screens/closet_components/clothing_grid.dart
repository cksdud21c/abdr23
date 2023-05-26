import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/model_clothing_item.dart';
import 'package:http/http.dart' as http;

class ClothingGrid extends StatefulWidget {
  List<ClothingItem> clothingItems;

  ClothingGrid({required this.clothingItems});

  @override
  State<ClothingGrid> createState() => _ClothingGridState();
}

class _ClothingGridState extends State<ClothingGrid> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(widget.clothingItems.length, (index) {
          return GestureDetector(
            onTap: () {
              _showDetailDialog(context, widget.clothingItems[index]);
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.network(
                widget.clothingItems[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [
              Image.network(item.imageUrl),
              // Add more details or customize the layout as needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                print(item.imageUrl);
                _showDeleteConfirmationDialog(context, item.imageUrl);
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String imgurl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                sendDeleteImageToServer(imgurl);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close both dialog windows
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> sendDeleteImageToServer(String imgurl) async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    var url = Uri.parse('http://34.170.39.54:6000/delete');
    var data = {'url': imgurl, 'id': id};
    var body = json.encode(data);
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

    if(response.statusCode == 200) {
      return ;
    }else{
      throw Exception('Failed to send deleteimg to server');
    }
  }
}


