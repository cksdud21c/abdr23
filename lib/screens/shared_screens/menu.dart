//파란색은 다 클래스 이름임.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color.fromARGB(255, 6, 67, 117)),
                child: ListTile(
                  title: Text(
                    "MOMA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop; //Drawer를 닫고 push
                  Navigator.pushNamed(context, '/now_emotion');
                },
                leading: const Icon(Icons.insert_emoticon),
                title: const Text(
                  "감정입력",
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop; //Drawer를 닫고 push
                  Navigator.pushNamed(context, '/input_place');
                },
                leading: const Icon(Icons.place),
                title: const Text(
                  "장소입력",
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop; //Drawer를 닫고 push
                  Navigator.pushNamed(context, '/closet');
                },
                leading: const Icon(Icons.folder_open),
                title: const Text(
                  "옷장",
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop; //Drawer를 닫고 push
                  Navigator.pushNamed(context, '/calender');
                },
                leading: const Icon(Icons.calendar_month),
                title: const Text(
                  "달력",
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop; //Drawer를 닫고 push
                  Navigator.pushNamed(context, '/profile');
                },
                leading: const Icon(Icons.account_circle),
                title: const Text(
                  "MY",
                ),
              ),
            ],
          ),
    );
  }
}