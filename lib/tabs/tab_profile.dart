// tabs/tab_profile.dart
//하단바의 프로필 버튼을 누르면 나오는 화면
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_auth.dart';

class TabProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 6, 67, 117),
         title: Text('프로필'),
       ),
       body : SingleChildScrollView(
         child: Column(
           children: [
             GestureDetector(
               onTap: (() {
                 Navigator.of(context).pushNamed('/info');
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
                     const ListTile(
                       title: Text("설정"),
                       trailing: Icon(Icons.settings),
                     )
                   ],
                 ),
               ),
             ),
             GestureDetector(
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
                     LoginOutButton(),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
     );
  }
}

class LoginOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    return TextButton(
        onPressed: () async {
          await authClient.logout();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('로그아웃!')));
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        },
        child: Text('로그아웃'));
  }
}