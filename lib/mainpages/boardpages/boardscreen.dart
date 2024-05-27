import 'package:flutter/material.dart';
import 'package:everytime/database_structure/board.dart';
import 'myBoards/best.dart';
import 'myBoards/hot.dart';
import 'myBoards/myComment.dart';
import 'myBoards/myScrap.dart';
import 'myBoards/myWrite.dart';
import 'totalboard_detail.dart';
// ignore_for_file: prefer_const_constructors

class BoardScreen extends StatelessWidget {
  final List<Board> myboards = [
    Board(boardId: "1", boardName: "내가 쓴 글"),
    Board(boardId: "2", boardName: "댓글 단 글"),
    Board(boardId: "3", boardName: "스크랩"),
    Board(boardId: "4", boardName: "HOT 게시판"),
    Board(boardId: "5", boardName: "BEST 게시판"),
  ];

  final List<Board> totalboards = [
    Board(boardId: "6", boardName: "죽전캠 자유게시판"),
    Board(boardId: "7", boardName: "천안캠 자유게시판"),
    Board(boardId: "8", boardName: "새내기게시판"),
    Board(boardId: "9", boardName: "졸업생게시판"),
    Board(boardId: "10", boardName: "정보게시판"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0a559c),
        title: Text(
          "게시판",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: myboards.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                title: Text(myboards[index].boardName),
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyWriteScreen(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyCommentScreen(),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyScrapScreen(),
                      ),
                    );
                  } else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HotScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BestScreen(),
                      ),
                    );
                  }
                },
              );
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: totalboards.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                title: Text(totalboards[index].boardName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TotalBoardDetailScreen(boardName: totalboards[index].boardName),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
