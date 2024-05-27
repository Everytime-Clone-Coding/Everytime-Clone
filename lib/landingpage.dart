import 'dart:async';
import 'package:everytime/loginpage.dart';
import 'package:everytime/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: prefer_const_constructors

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    // 1초간 대기
    await Future.delayed(Duration(seconds: 3));

    // 로그인 상태 확인
    bool isLoggedIn = await _getLoginStatus();

    // 로그인 상태에 따라 페이지 전환
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<bool> _getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a559c),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 300, 20, 20),
        child: Column(children: <Widget>[
          Text(
            "똑똑한",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          Text(
            "단곰생활",
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          LinearProgressIndicator(
            color: Colors.lightBlueAccent[400],
          ),
        ]),
      ),
    );
  }
}
