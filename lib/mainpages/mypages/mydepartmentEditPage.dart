import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mypageProvider.dart';

List<String> departments = [
  "소프트웨어학과",
  "컴퓨터공학과",
  "모바일시스템공학과",
  "통계데이터사이언스학과",
  "사이버보안학과",
  "SW융합학부"
];

class MyDepartmentEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("학과 변경"),
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
    _nowValue = Provider.of<MyPageProvider>(context, listen: false).department;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Column(
        children: [
          DropdownButtonFormField(
            value: _nowValue,
            onChanged: (String? newValue) {
              setState(() {
                _nowValue = newValue!;
              });
            },
            items: departments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<MyPageProvider>(context, listen: false)
                  .changeDepartment(_nowValue);
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
