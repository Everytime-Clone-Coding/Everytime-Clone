import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("마이페이지스크린입니다."),
    );
  }
}