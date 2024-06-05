import 'package:flutter/material.dart';

class TimeTableProvider with ChangeNotifier {
  String _selectedTimeTable = "2024년 1학기";
  String _avgGrade = "";
  late Future<List<dynamic>> _semesterList;

  String get selectedTimeTable => _selectedTimeTable;

  String get avgGrade => _avgGrade;

  Future<List<dynamic>> get semesterList => _semesterList;

  void changeTimeTable(String newTimeTable) {
    _selectedTimeTable = newTimeTable;
    notifyListeners();
  }

  void changeAvgGrade(String newAvgGrade) {
    _avgGrade = newAvgGrade;
    notifyListeners();
  }

  void changeSemesterList(Future<List<dynamic>> newSemesterList) {
    _semesterList = newSemesterList;
    notifyListeners();
  }
}
