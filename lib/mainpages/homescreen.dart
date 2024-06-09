import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_structure/board.dart';
import 'boardpages/totalboard_detail.dart';
import 'boardpages/boardscreen.dart';
import 'mypages/mypageProvider.dart';
import 'boardpages/myBoards/myWrite.dart';
import 'boardpages/myBoards/myScrap.dart';
import 'boardpages/myBoards/myComment.dart';
// ignore_for_file: prefer_const_constructors

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BoardScreen boardScreen = BoardScreen();

  @override
  Widget build(BuildContext context) {
    String _department = Provider.of<MyPageProvider>(context).department;
    String _nickname = Provider.of<MyPageProvider>(context).nickname;
    String _profile = Provider.of<MyPageProvider>(context).profile;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Color(0xff0a559c),
                      borderRadius: BorderRadius.circular(60)),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("${_profile}"),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(
                      _nickname,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      _department,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildCard("현재 진행 중인 학사 일정", Colors.lightBlue.shade50),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildCard("오늘의 수업", Colors.pink.shade50),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.account_balance,
                    size: 30,
                  ),
                  onPressed: () async {
                    final url = Uri.parse('https://www.dankook.ac.kr/web/kor');
                    if (await canLaunchUrl(url)) {
                    launchUrl(url);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.book,
                    size: 30,
                  ),
                  onPressed: () async {
                    final url = Uri.parse('https://lib.dankook.ac.kr/');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.language,
                    size: 30,
                  ),
                  onPressed: () async {
                    final url = Uri.parse('https://portal.dankook.ac.kr/');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.grid_on,
                    size: 30,
                  ),
                  onPressed: () async {
                    final url = Uri.parse('https://www.dankook.ac.kr/web/kor/-69');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  onPressed: () async {
                    final url = Uri.parse('https://www.dankook.ac.kr/web/kor/-2014-');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSectionHeader("주요 게시판"),
            _buildListTile(context, boardScreen.totalboards, "죽전캠 자유게시판"),
            _buildListTile(context, boardScreen.totalboards, "천안캠 자유게시판"),
            _buildListTile(context, boardScreen.totalboards, "정보게시판"),
            SizedBox(height: 16),
            _buildSectionHeader("나의 게시판"),
            _buildListTile(context, boardScreen.myboards, "내가 쓴 글"),
            _buildListTile(context, boardScreen.myboards, "댓글 단 글"),
            _buildListTile(context, boardScreen.myboards, "스크랩"),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15), // 둥근 테두리 설정
      ),
      child: Center(child: Text(title, textAlign: TextAlign.start)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListTile(BuildContext context, List<Board> boards, String boardName) {
    return ListTile(
        contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      title: Text(boardName),
      onTap: () {
        Board selectedBoard = findBoardByName(boards, boardName);
        if (selectedBoard != null) {
          if (boards == boardScreen.totalboards) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TotalBoardDetailScreen(boardName: selectedBoard.boardName),
              ),
            );
          } else if (boards == boardScreen.myboards) {
            if (boardName == "내가 쓴 글") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyWriteScreen(),
                ),
              );
            } else if (boardName == "댓글 단 글") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyCommentScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyScrapScreen(),
                ),
              );
            }
          }
        }
      },
    );
  }
}

Board findBoardByName(List<Board> boards, String boardName) {
  return boards.firstWhere((board) => board.boardName == boardName);
}

