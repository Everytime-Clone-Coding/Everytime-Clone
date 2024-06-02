

class MyClass {
  String classname;
  double grade;
  int day;
  int startime;
  int endtime;

  MyClass({
    required this.classname,
    required this.grade,
    required this.day,
    required this.startime,
    required this.endtime,
  });

  factory MyClass.fromMap(Map<dynamic, dynamic> map) {
    return MyClass(
        classname: map['classname'],
        grade: map['grade'],
        day: map['day'],
        startime: map['startime'],
        endtime: map['endtime']);
  }
}
