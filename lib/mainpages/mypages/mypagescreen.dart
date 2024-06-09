import 'package:everytime/mainpages/mypages/mydepartmentEditPage.dart';
import 'package:everytime/mainpages/mypages/mynicknameEditPage.dart';
import 'package:everytime/mainpages/mypages/myprofileEditPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../loginpage.dart';
import 'mypageProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPageScreen(),
    );
  }
}

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String? profile = null;

  @override
  Widget build(BuildContext context) {
    var boxWidth = MediaQuery.of(context).size.width * 0.9;
    String _department = Provider.of<MyPageProvider>(context).department;
    String _nickname = Provider.of<MyPageProvider>(context).nickname;
    String _profile = Provider.of<MyPageProvider>(context).profile;

    return Scaffold(
      appBar: AppBar(
        title: Text("내 정보"),
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: boxWidth,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: Row(
                    children: [
                      // 원형 프로필 이미지
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("${_profile}"),
                          backgroundColor:
                              profile != null ? Colors.white : Colors.white12,
                        ),
                      ),
                      // 닉네임, 이름, 학과, 학번)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${_nickname}",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18)),
                          Text("김단국",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 15)),
                          Text("${_department} 32999999",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 15)),
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("계정",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      ListTile(
                        title: Text("학과 변경",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyDepartmentEditScreen()));
                        },
                      ),
                      ListTile(
                        title: Text("비밀번호 변경",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text("이메일 변경",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        onTap: () {},
                      ),
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("커뮤니티",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      ListTile(
                        title: Text("닉네임 변경",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyNicknameEditPage()));
                        },
                      ),
                      ListTile(
                        title: Text("프로필 이미지 변경",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyProfileEditPage()));
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                width: boxWidth,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(color: Colors.red),
                child: InkWell(
                  onTap: () async {
                    await _signOut(context);
                  },
                  child: Center(
                    child: Text(
                      "로그아웃",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: boxWidth,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(color: Colors.red),
                child: InkWell(
                  onTap: () async {
                    await _deleteId(context);
                  },
                  child: Center(
                    child: Text(
                      "회원탈퇴",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("로그아웃 중 오류가 발생했습니다."),
        ),
      );
    }
  }

  Future<void> _deleteId(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await _deleteUserFromDatabase(user);
        await user.delete();
        await FirebaseAuth.instance.signOut();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원탈퇴 완료')),
        ).closed.then((SnackBarClosedReason reason) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원탈퇴 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  Future<void> _deleteUserFromDatabase(User user) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    try {
      await usersRef.child(user.uid).remove();
    } catch (error) {
      print('Error deleting user from database: $error');
    }
  }
}
