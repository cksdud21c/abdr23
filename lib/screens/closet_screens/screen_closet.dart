import 'package:flutter/material.dart';
import 'package:untitled/screens/closet_screens/screen_closetbody.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';

class ClosetScreen extends StatelessWidget {
  ClosetScreen({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text('옷장'),
      ),
      endDrawer : SafeArea(
        child:
        Menu(),
      ),
      body: ClosetBodyScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFFFD725A),
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: Bottombar(),
    );
  }
}