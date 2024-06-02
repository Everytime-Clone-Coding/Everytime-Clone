import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'timetableProvider.dart';

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
                        .changeTimeTable('2024년 1학기');
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
                        .changeTimeTable('2023년 2학기');
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
                        .changeTimeTable('2023년 1학기');
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }
}
