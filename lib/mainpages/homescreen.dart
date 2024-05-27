import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("홈스크린입니다."),
    );
  }
}