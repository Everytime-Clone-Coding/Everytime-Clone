import 'dart:async';

import 'package:everytime/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      Get.offAll(MainPage());
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              LinearProgressIndicator()
            ]),
      ),
    );
  }
}
