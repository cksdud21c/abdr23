// main.dart
import 'package:flutter/material.dart';
import 'package:untitled/models/model_input_emotion.dart';
import 'models/model_place_clothes_recommend.dart';
import 'screens/screen_splash.dart';
import 'screens/screen_login.dart';
import 'screens/screen_register.dart';
import 'screens/input_emotion_screens/screen_now_emotion.dart';
import 'screens/input_emotion_screens/screen_hope_emotion.dart';
import 'screens/input_place_screens/screen_input_place.dart';
import 'screens/input_place_screens/screen_recommend_clothes.dart';
import 'screens/input_emotion_screens/screen_recommend_place.dart';
import 'package:untitled/tabs/tab_calender.dart';
import 'package:untitled/tabs/tab_profile.dart';
import 'package:untitled/screens/closet_screens/screen_closet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/models/model_auth.dart';
import 'package:untitled/screens/closet_screens/screen_camera.dart';
import 'package:untitled/screens/screen_home.dart';
import 'package:untitled/screens/screen_info.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:untitled/models/model_input_place.dart';
import 'package:untitled/models/model_clothes_recommend.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //flutter의 시작은 main().
  //main에서 runapp전에 비동기로 데이터를 다뤄야할 경우 반드시 써줘야하는 코드.
  //asynchronous(비동기) vs synchronous(동기)
  //동기 : 동시에. client가 server에게 데이터를 요청하면, server가 client에게 return해주기전까지 client는 다른 활동을 할 수 없으면 기다려야함.
  //비동기 : 동시에X. return을 기다릴 필요 없이 요청하고 다른 활동도 가능함.
  //로그인 여부를 확인하기위해 파이어베이스에서 데이터를 가져와야하므로, async활동이 필요함.
  await initializeDateFormatting();
  //await A : A 끝날 때 까지 기다려라.
  //달력기능을 쓰기 위하여, 날짜형식 초기화.
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    //기본 Firebase옵션으로 Firebase앱을 초기화.
  );
  runApp(MyApp());//따라서, 파이어베이스 앱이 초기화가 되면 MyApp클래스 실행.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {//BuildContext: 위젯 트리에서 현재 위젯(MYApp)의 위치
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => InputEmotionModel()),
        ChangeNotifierProvider(create: (_) => InputPlaceModel()),
        ChangeNotifierProvider(create: (_) => PlaceClothesRecommendModel()),
        ChangeNotifierProvider(create: (_) => ClothesRecommendModel()),
      ],
      child: MaterialApp(//그냥 기본 디자인 방식.
        routes: { //앱에서 사용할 화면들의 경로를 지정. 화면이 다수일 경우 Navigator보다 편리
          '/splash': (context) => SplashScreen(),//splashScreen의 경로는 /splash.
          '/login': (context) => LoginScreen(), //loginScreen의 경로는 /login.
          '/register': (context) => RegisterScreen(), //registerScreen의 경로는 /register.
          '/now_emotion' : (context) => NowEmotionScreen(),
          '/hope_emotion' : (context) => HopeEmotionScreen(),
          '/closet' : (context) => ClosetScreen(),
          '/calender' : (context) => TabCalender(),
          '/profile' : (context) => TabProfile(),
          '/input_place' : (context) => InputPlaceScreen(),
          '/camera' : (context) => CameraScreen(),
          '/home' : (context) =>HomeScreen(),
          '/info' : (context) => InfoScreen(),
          '/screen_recommend_clothes' : (context) => RecommendClothesScreen(),
          '/screen_recommend_place' : (context) => RecommendPlaceScreen(),
        },
        initialRoute: '/splash', //앱 실행시 처음 나오는 화면은 스플래시화면으로 설정.
      ),
    );
  }
}