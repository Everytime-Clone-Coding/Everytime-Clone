import 'package:flutter/material.dart';

class TimeTableProvider with ChangeNotifier {
  // TODO : findById로 찾을 수 있게 기능 추가
  String _selectedTimeTable = "2024년 1학기: 시간표 1";

  String get selectedTimeTable => _selectedTimeTable;

  void changeTimeTable(String newTimeTable) {
    _selectedTimeTable = newTimeTable;
    notifyListeners();
  }
}
