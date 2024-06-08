import 'package:everytime/mainpages/mypages/mydepartmentEditPage.dart';
import 'package:everytime/mainpages/mypages/mynicknameEditPage.dart';
import 'package:everytime/mainpages/mypages/myprofileEditPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mypageProvider.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => MyPageProvider(),
//       child: MyApp(),
//     ),
//   );
// }

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
                  margin: EdgeInsets.all(20),
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
              Container(
                  width: boxWidth,
                  margin: EdgeInsets.all(15),
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
              Container(
                  width: boxWidth,
                  margin: EdgeInsets.all(15),
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
              Container(
                width: boxWidth,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(color: Colors.red),
                child: InkWell(
                  onTap: () {},
                  child: Center(
                    child: Text(
                      "회원 탈퇴",
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
}
