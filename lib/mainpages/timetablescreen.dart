import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mainpages/timetableProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TimeTableScreen(),
    );
  }
}

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

// TODO : 선택된 시간표에 맞게 시간표 생성하는 기능 추가 예정
class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    var selectedTimetable =
        Provider.of<TimeTableProvider>(context).selectedTimeTable;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTimetable ?? "default"),
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TimetableList()),
                );
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[SelectedTimetable()],
      ))),
    );
  }
}

class SelectedTimetable extends StatefulWidget {
  @override
  _SelectedTimetableState createState() => _SelectedTimetableState();
}

class _SelectedTimetableState extends State<SelectedTimetable> {
  @override
  Widget build(BuildContext context) {
    var timetableWidth = MediaQuery.of(context).size.width * 0.8;
    var timetableHeight = MediaQuery.of(context).size.height;

    var selectedTimetable =
        Provider.of<TimeTableProvider>(context).selectedTimeTable;
    List<String> days = [' ', '월', '화', '수', '목', '금'];

    return Center(
      child: SizedBox(
        width: timetableWidth,
        height: timetableHeight,
        child: SingleChildScrollView(
          child: Row(
            children: List<Widget>.generate(days.length, (column) {
              return Column(
                children: List<Widget>.generate(10, (time) {
                  print(
                      '>>>> Widget Render!!! col: $column time: $time'); // 테스트 용

                  if (time == 0) {
                    return Container(
                        // 1행 요일
                        color: Colors.lightBlueAccent,
                        width: double.infinity,
                        height: 50,
                        child: Text("${days[column]}",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)));
                  } else {
                    if (column == 0) {
                      return Container(
                          // 1열 시간
                          color: Colors.lightBlueAccent,
                          width: double.infinity,
                          height: 50,
                          child: Text("${(time + 7) % 12 + 1}",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45)));
                    } else {
                      return Container(
                          color: Colors.lightBlueAccent,
                          width: double.infinity,
                          height: 50,
                          child: Text("${days[column]}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)));
                    }
                  }
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class TimetableList extends StatelessWidget {
  const TimetableList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TimeTableProvider(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text("시간표 목록"),
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_rounded)),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text(
                    '2024년 1학기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('시간표 1',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  onTap: () {
                    Provider.of<TimeTableProvider>(context, listen: false)
                        .changeTimeTable('2024년 1학기: 시간표 1');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    '2023년 2학기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('시간표 1',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  onTap: () {
                    Provider.of<TimeTableProvider>(context, listen: false)
                        .changeTimeTable('2023년 2학기: 시간표 1');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    '2023년 1학기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('시간표 1',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  onTap: () {
                    Provider.of<TimeTableProvider>(context, listen: false)
                        .changeTimeTable('2023년 1학기: 시간표 1');
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }
}