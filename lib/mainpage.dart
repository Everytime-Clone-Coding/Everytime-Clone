import 'package:flutter/material.dart';
import 'mainpages/boardpages/boardscreen.dart';
import 'mainpages/chatpages/chatscreen.dart';
import 'mainpages/homescreen.dart';
import 'mainpages/mypages/mypagescreen.dart';
import 'mainpages/timetablepages/timetablescreen.dart';
// ignore_for_file: prefer_const_constructors

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home_outlined)),
    BottomNavigationBarItem(label: 'TimeTable', icon: Icon(Icons.grid_on)),
    BottomNavigationBarItem(
        label: 'Board', icon: Icon(Icons.assignment_outlined)),
    BottomNavigationBarItem(
        label: 'Chat', icon: Icon(Icons.chat_bubble_outline)),
    BottomNavigationBarItem(
        label: 'MyPage', icon: Icon(Icons.account_circle_outlined)),
  ];
  List pages = [
    HomeScreen(),
    TimeTableScreen(),
    BoardScreen(),
    ChatScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? AppBar(
        leading: Image.asset('assets/dku.png'),
        actions: const [
          IconButton(icon: Icon(Icons.search), onPressed: null),
        ],
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff0a559c),
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.white,
        selectedFontSize: 20,
        unselectedFontSize: 10,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: bottomItems,
      ),
      body: pages[_selectedIndex],
    );
  }
}
