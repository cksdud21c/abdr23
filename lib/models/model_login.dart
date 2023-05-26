// model/model_login.dart
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier { //상태변경알리미
  String email = ""; //상태를 저장하는 변수
  String password = ""; //상태를 저장하는 변수

  void setEmail(String email) {
    this.email = email;
    notifyListeners();//변경이 이루어졌으므로, ChangeNotifierProvider에세 변경되었음을 알림
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }
}