// screens/screen_splash.dart
//앱 아이콘을 클릭하고 로딩에 걸리는 1~3초사이 띄워지는 화면.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//shared_preference : pubsepc.yaml의 설명 읽었으면 이거 주석 보셈
//isLogin값을 가져와서 true면 로그인된 상황이므로 /index화면으로 넘어가고,
//False면 로그인을 해야하므로 /login화면으로 보내면 됨.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen>{
//플러터에서 비동기사용한다 == Future(미래),async(비동기),await(기다려)는 한쌍.
  Future<bool> checkLogin() async {//Future<bool> 해당 함수를 bool형식으로 반환할겁니다.
    SharedPreferences prefs = await SharedPreferences.getInstance(); //isLogin값을 가져옴.
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  void moveScreen() async {
    await checkLogin().then((isLogin){//await checkLogin() 후에 .then(isLogin){} . isLogin은 chekLogin()의 반환값.
      if(isLogin){
        //pushReplacementNamed(): 현재화면을 스택에서 제거하고 새로운 화면으로 교체
        Navigator.of(context).pushReplacementNamed('/home');//로그인 되었으면 index화면으로
      } else {
        Navigator.of(context).pushReplacementNamed('/login');//로그인 안되었으면 login화면으로
      }
    });
  }//로그인 여부를 판단하여 홈화면으로 갈지, 로그인 화면으로 갈지 결정.


  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2000), (){
      moveScreen();
    });
  }//2초 딜레이를 가지고 moveScreen()실행.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: Image.asset('assets/images/gromit.png'),
        )
    );
  }//스플래시화면 구성도. 그럼 flutter_launcher_icons.yaml필요 없고, 그냥 여기다가 넣으면 될 듯?
}