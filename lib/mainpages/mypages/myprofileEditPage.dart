import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mypageProvider.dart';

List<String> profiles = [
  "assets/profile1.png",
  "assets/profile2.png",
  "assets/profile3.png"
];

class MyProfileEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 이미지 변경"),
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        backgroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: MyDepartment(),
      ),
    );
  }
}

class MyDepartment extends StatefulWidget {
  @override
  _MyDepartmentState createState() => _MyDepartmentState();
}

class _MyDepartmentState extends State<MyDepartment> {
  late String _nowValue;

  // 초기값 할당 (provider 값)
  @override
  void initState() {
    super.initState();
    _nowValue = Provider.of<MyPageProvider>(context, listen: false).profile;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("${_nowValue}"),
              backgroundColor:
                  _nowValue != null ? Colors.white : Colors.white12,
            ),
          ),
          DropdownButtonFormField(
            value: _nowValue,
            onChanged: (String? newValue) {
              setState(() {
                _nowValue = newValue!;
              });
            },
            items: List.generate(profiles.length, (index) {
              return DropdownMenuItem<String>(
                value: profiles[index],
                child: index == 0
                    ? Text("브이 단곰이")
                    : index == 1
                        ? Text("러닝 단곰이")
                        : Text("신난 단곰이"),
              );
            }),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<MyPageProvider>(context, listen: false)
                  .changeProfile(_nowValue);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "변경",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
