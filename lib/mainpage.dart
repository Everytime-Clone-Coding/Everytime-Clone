import 'package:flutter/material.dart';

import 'mainpages/boardscreen.dart';
import 'mainpages/chatscreen.dart';
import 'mainpages/homescreen.dart';
import 'mainpages/mypagescreen.dart';
import 'mainpages/timetablescreen.dart';

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
      appBar: AppBar(
        leading: Image.asset('assets/dku.png'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.deepPurpleAccent,
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
