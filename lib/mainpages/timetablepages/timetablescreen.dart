import 'package:everytime/database_structure/myclass.dart';
import 'package:everytime/mainpages/timetablepages/gradeEditScreen.dart';
import 'package:everytime/mainpages/timetablepages/timetableList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timetableProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TimeTableScreen(),
    );
  }
}

var _selectedTimetable;
late Future<List<dynamic>> _semesterList;

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    _selectedTimetable =
        Provider.of<TimeTableProvider>(context).selectedTimeTable;

    return Scaffold(
      // 앱바 : 현재 시간표 및 다른 시간표 선택 버튼
      appBar: AppBar(
        title: Text(_selectedTimetable ?? "default"),
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimetableList()),
                );
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SelectedTimetable(),
                  SizedBox(
                    height: 15,
                  ),
                  GradeCalculator(),
                  SizedBox(
                    height: 15,
                  )
                ],
              ))),
    );
  }
}

// 현재 시간표
class SelectedTimetable extends StatefulWidget {
  @override
  _SelectedTimetableState createState() => _SelectedTimetableState();
}

class _SelectedTimetableState extends State<SelectedTimetable> {
  final List<Color> classColors = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
    Colors.lightGreen,
    Colors.lightBlueAccent,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.pinkAccent
  ];

  Future<List<dynamic>> getData() async {
    FirebaseDatabase realtime = FirebaseDatabase.instance;
    DataSnapshot snapshot =
        await realtime.ref("timetables").child("semesters").get();
    List<dynamic> semesterList = snapshot.value as List<dynamic>;
    return semesterList;
  }

  @override
  void initState() {
    super.initState();
    _semesterList = getData();
  }

  @override
  Widget build(BuildContext context) {
    var timetableWidth = MediaQuery.of(context).size.width * 0.9;
    var timetableHeight = MediaQuery.of(context).size.height * 0.7;
    const dayRange = 6;
    const timeRange = 10;
    var timeWidth = timetableWidth / (dayRange);
    var timeHeight = timetableHeight * 0.98 / (timeRange);
    Provider.of<TimeTableProvider>(context).changeSemesterList(_semesterList);

    var selectedTimetable =
        Provider.of<TimeTableProvider>(context).selectedTimeTable;
    List<String> days = [' ', '월', '화', '수', '목', '금'];

    return FutureBuilder(
        future: _semesterList,
        builder: (context, snapshot) {
          // 데이터 로딩중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                width: timetableWidth,
                height: timetableHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 3)),
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
              width: timetableWidth,
              height: timetableHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 3)),
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
              width: timetableWidth,
              height: timetableHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 3)),
              child: Center(
                child: Expanded(
                  child: Row(
                    children: List<Widget>.generate(days.length, (column) {
                      // 해당 요일의 과목 리스트 추출
                      List<MyClass> dayClasses = [];
                      for (var c in nowClasses) {
                        if (c.day == column) {
                          dayClasses.add(c);
                        }
                      }
                      return Expanded(
                        child: Column(
                          children: List<Widget>.generate(timeRange, (time) {
                            int viewTime = (time + 7);
                            if (time == 0) {
                              // 1행 요일
                              return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black12, width: 1)),
                                  width: timeWidth,
                                  height: timeHeight,
                                  child: Text("  ${days[column]}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45)));
                            } else {
                              // 1열 시간
                              if (column == 0) {
                                return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black12,
                                                width: 1))),
                                    width: timeWidth,
                                    height: timeHeight,
                                    child: Text("   ${viewTime % 12 + 1}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45)));
                              } else {
                                for (var c in dayClasses) {
                                  // 해당 시간의 과목이라면
                                  if (c.startime == viewTime + 1) {
                                    // 제일 윗 블록이라면 강의명 출력
                                    return Container(
                                        color: classColors[
                                                (column) % classColors.length]
                                            .withOpacity(0.3),
                                        width: timeWidth,
                                        height: timeHeight,
                                        child: Center(
                                            child: Text("${c.classname}",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54))));
                                  }
                                  // 그외의 블록은 색칠만
                                  else if (c.startime < viewTime + 1 &&
                                      viewTime + 1 < c.endtime) {
                                    // 시간표
                                    return Container(
                                        color: classColors[
                                                (column) % classColors.length]
                                            .withOpacity(0.3),
                                        width: timeWidth,
                                        height: timeHeight,
                                        child: Center(child: Text(" ")));
                                  }
                                }
                                // 시간표
                                return Container(
                                    color: Colors.white,
                                    width: timeWidth,
                                    height: timeHeight,
                                    child: Text(
                                      " ",
                                    ));
                              }
                            }
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          }
        });
  }
}

//학점 계산기
class GradeCalculator extends StatelessWidget {
  const GradeCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    var boxWidth = MediaQuery.of(context).size.width * 0.9;

    return FutureBuilder(
        future: _semesterList,
        builder: (context, snapshot) {
          // 데이터 로딩중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 3)),
                width: boxWidth,
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
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
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              child: Text("${snapshot.error}"),
            );
          }
          // 데이터 획득 성공
          else {
            List<dynamic> semesterList = snapshot.data as List<dynamic>;
            List<MyClass> nowClasses = [];
            double sumGrade = 0.0;
            var avgGrade;

            // 학기 리스트에서 선택한 학기의 데이터 조회
            for (var s in semesterList) {
              // 선택한 학기와 일치하면
              if (s.containsKey(_selectedTimetable)) {
                Map<dynamic, dynamic> nowSemester = s[_selectedTimetable];
                List<dynamic> classes = nowSemester['classes'];
                // 클래스 리스트 추가
                for (var c in classes) {
                  nowClasses.add(MyClass.fromMap(c as Map<dynamic, dynamic>));
                }
                break;
              }
            }
            // 학기 평균 학점 계산
            for (var c in nowClasses) {
              sumGrade += c.grade;
            }
            avgGrade = (sumGrade / nowClasses.length).toStringAsFixed(2);
            Provider.of<TimeTableProvider>(context).changeAvgGrade(avgGrade);

            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 3)),
              width: boxWidth,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "학점 계산기",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GradeEditScreen()));
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                  Row(children: [
                    Text("평균 학점 ",
                        style: TextStyle(fontSize: 15, color: Colors.black87)),
                    Text("${avgGrade}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    Text(" / 4.5",
                        style: TextStyle(fontSize: 13, color: Colors.black26)),
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Text("취득 학점 ",
                        style: TextStyle(fontSize: 15, color: Colors.black87)),
                    Text("120",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    Text(" / 140",
                        style: TextStyle(fontSize: 13, color: Colors.black26)),
                  ])
                ],
              ),
            );
          }
        });
  }
}