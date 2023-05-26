//파란색은 다 클래스 이름임.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Bottombar extends StatelessWidget {

  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //fixed : 클릭되었을 때 커진다거나 라벨이 fade in한다던가 이벤트는 발생하지 않음.
        iconSize: 44,
        onTap: (index) {
          if(index==0){
            Navigator.of(context).pushNamed('/calender');
          }
          else if(index==1){
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
          }
          else if(index==2){
            Navigator.of(context).pushNamed('/profile');
          }
        }, //터치 했을 경우 상태 변경
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month,color: Colors.blue), label: '달력'),
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.blue), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: Colors.blue), label: '프로필'),
        ],//하단바 항목
      );
  }
}