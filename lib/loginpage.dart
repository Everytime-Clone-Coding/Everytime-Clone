import 'package:everytime/signuppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: prefer_const_constructors

import 'mainpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _statusMessage = '';

  Future<void> _login() async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _statusMessage = '이메일이 일치하는 계정이 없습니다.';
        } else if (e.code == 'wrong-password') {
          _statusMessage = '비밀번호가 틀렸습니다.';
        } else {
          _statusMessage = '로그인 실패';
        }
      });
    }
  }

  void _navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 70, 20, 20),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/Character_logo.jpg'),
                    const Text(
                      "똑똑한\n단곰생활",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "이메일",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "비밀번호",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  obscureText: true,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff0a559c),
                  minimumSize: Size(500, 30),
                  shape: BeveledRectangleBorder(),
                ),
                onPressed: _login,
                child: Text(
                  "로그인",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "아이디/비밀번호 찾기",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: _navigateToSignUpPage,
                child: Text(
                  "회원가입",
                  style: TextStyle(
                  color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(_statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
