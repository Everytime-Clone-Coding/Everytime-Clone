import 'package:flutter/material.dart';
import 'package:everytime/landingpage.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DanGom Life',
      home: LandingPage(),
    );
  }
}
