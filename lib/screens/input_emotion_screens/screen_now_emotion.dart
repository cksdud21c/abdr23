import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NowEmotionScreen extends StatelessWidget {
  const NowEmotionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text('감정 입력 : 현재 감정'),
      ),
      endDrawer : SafeArea(
          child:
          Menu()
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: (() {
                sendNowEmotionToServer('neg', id!);
                Navigator.of(context).pushNamed('/hope_emotion');
              }),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
                  children: [
                    //Image.asset('assets/images/gromit.png'),
                    const ListTile(
                      title: Text("부정"),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    )
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (() {
                sendNowEmotionToServer('neu', id!);
                Navigator.of(context).pushNamed('/hope_emotion');
              }),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
                  children: [
                    //Image.asset('assets/images/gromit.png'),
                    const ListTile(
                      title: Text("중립"),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    )
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (() {
                sendNowEmotionToServer('pos',id!);
                Navigator.of(context).pushNamed('/hope_emotion');
              }),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
                  children: [
                    //Image.asset('assets/images/gromit.png'),
                    const ListTile(
                      title: Text("긍정"),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }
}

// 텍스트 값을 Flask 서버에 보내는 함수(보내지는거 확인완료.근데 애뮬레이터에서 한글이 안쳐짐. 이건 해결해야함.)
Future<void> sendNowEmotionToServer(String ne, String id) async {
  var url = Uri.parse('http://34.170.39.54:6000/ne');
  var data = {'ne': ne, 'id': id};
  var body = json.encode(data);
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

  if(response.statusCode == 200) {
    print(json.decode(response.body));
    return;
  }else{
    throw Exception('Failed to send now emotion to server');
  }
}
