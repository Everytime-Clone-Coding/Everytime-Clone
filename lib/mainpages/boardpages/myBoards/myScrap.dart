import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class MyScrapScreen extends StatelessWidget {
  const MyScrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0a559c),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "스크랩",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text('스크랩 화면'),
      ),
    );
  }
}