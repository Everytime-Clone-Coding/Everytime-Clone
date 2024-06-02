import 'package:everytime/database_structure/myclass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'timetableProvider.dart';

class GradeEditScreen extends StatefulWidget {
  @override
  _GradeEditScreenState createState() => _GradeEditScreenState();
}

class _GradeEditScreenState extends State<GradeEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("학점 계산기"),
            titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear))
            ],
            automaticallyImplyLeading: false),
        body: Center(
            child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GradeSummary(),
                    SizedBox(
                      height: 15,
                    ),
                    GradeOfSemester(),
                  ],
                ))));
  }
}

// 학점 요약
class GradeSummary extends StatelessWidget {
  const GradeSummary({super.key});

  @override
  Widget build(BuildContext context) {
    var boxWidth = MediaQuery.of(context).size.width * 0.9;
    var boxHeight = MediaQuery.of(context).size.width * 0.55;
    var avgGrade = Provider.of<TimeTableProvider>(context).avgGrade;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 3)),
        width: boxWidth,
        height: boxHeight,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Wrap(children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "전체 평점",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        Text("${avgGrade}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Text(" / 4.5",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black26))
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "취득 학점",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        Text("120",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Text(" / 140",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black26))
                      ],
                    )
                  ],
                ),
              ],
            ),
            Container(
                width: boxWidth * 0.8,
                height: boxHeight * 0.55,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/tempGraph.png'))),
          ])
        ]));
  }
}

// 학기 별 학점
class GradeOfSemester extends StatelessWidget {
  const GradeOfSemester({super.key});

  @override
  Widget build(BuildContext context) {
    var boxWidth = MediaQuery.of(context).size.width * 0.9;
    var selectedTimetable =
        Provider.of<TimeTableProvider>(context).selectedTimeTable;
    late Future<List<dynamic>> semesterList =
        Provider.of<TimeTableProvider>(context).semesterList;

    return Container(
        child: Wrap(children: [
      Container(
          margin: EdgeInsets.all(10),
          child: Text(
            "${selectedTimetable}",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
      FutureBuilder(
          future: semesterList,
          builder: (context, snapshot) {
            // 데이터 로딩중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12, width: 3)),
                  width: boxWidth,
                  child: Center(
                      child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ), // 로딩 바 표시
                  )));
            }
            // 에러 발생
            else if (snapshot.hasError == true) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 3)),
                width: boxWidth,
                child: Text("${snapshot.error}"),
              );
            }
            // 데이터 획득 성공
            else {
              List<dynamic> semesterList = snapshot.data as List<dynamic>;
              List<MyClass> nowClasses = [];
              // 학기 리스트에서 선택한 학기의 데이터 조회
              for (var s in semesterList) {
                // 선택한 학기와 일치하면
                if (s.containsKey(selectedTimetable)) {
                  Map<dynamic, dynamic> nowSemester = s[selectedTimetable];
                  List<dynamic> classes = nowSemester['classes'];
                  // 클래스 리스트 추가
                  for (var c in classes) {
                    nowClasses.add(MyClass.fromMap(c as Map<dynamic, dynamic>));
                  }
                  break;
                }
              }

              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12, width: 3)),
                  width: boxWidth,
                  child: FittedBox(
                      child: Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            dataTextStyle: TextStyle(fontSize: 13),
                            dataRowHeight: 22,
                            columns: [
                              DataColumn(
                                  label: Text("과목명   ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45))),
                              DataColumn(
                                  label: Text("학점",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45))),
                              DataColumn(
                                  label: Text("성적",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45))),
                            ],
                            rows: [
                              for (var c in nowClasses)
                                DataRow(cells: [
                                  DataCell(Text("${c.classname}")),
                                  DataCell(Text(
                                      "${c.grade == 4.5 ? 'A+' : c.grade == 4.0 ? 'A' : c.grade == 3.5 ? 'B+' : c.grade == 3.0 ? 'B' : c.grade == 2.5 ? 'C+' : c.grade == 2.0 ? 'C' : 'F'}")),
                                  DataCell(Text("${c.grade}")),
                                ]),
                            ],
                          )
                        ],
                      )
                    ],
                  )));
            }
          })
    ]));
  }
}
