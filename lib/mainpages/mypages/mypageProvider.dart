import 'package:flutter/material.dart';

class MyPageProvider with ChangeNotifier {
  String _department = "소프트웨어학과";
  String _email = "dankook@dankook.ac.kr";
  String _nickname = "단곰이";
  String _profile = "assets/profile1.png";

  String get department => _department;

  String get email => _email;

  String get nickname => _nickname;

  String get profile => _profile;

  void changeDepartment(String newDepartment) {
    _department = newDepartment;
    notifyListeners();
  }

  void changeEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void changeNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void changeProfile(String profile) {
    _profile = profile;
    notifyListeners();
  }
}
