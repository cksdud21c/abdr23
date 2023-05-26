// models/model_register.dart
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String id = "";
  String pw = "";
  String pwconfirm = "";
  String gender="";
  String age="";

  void setId(String id) {
    this.id = id;
    notifyListeners();
  }

  void setPw(String pw) {
    this.pw = pw;
    notifyListeners();
  }

  void setPwConfirm(String pwconfirm) {
    this.pwconfirm = pwconfirm;
    notifyListeners();
  }

  void setGender(String gender) {
    this.gender = gender;
    notifyListeners();
  }

  void setAge(String age) {
    this.age = age;
    notifyListeners();
  }
}