import 'package:everytime/mainpages/boardpages/writing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:everytime/database_structure/post.dart';
import 'contentdetail.dart';
import 'package:intl/intl.dart';
// ignore_for_file: prefer_const_constructors

class TotalBoardDetailScreen extends StatefulWidget {
  final String boardName;

  const TotalBoardDetailScreen({super.key, required this.boardName});

  @override
  _TotalBoardDetailScreenState createState() => _TotalBoardDetailScreenState();
}

class _TotalBoardDetailScreenState extends State<TotalBoardDetailScreen> {
  late DatabaseReference _postsRef;
  List<Post> _posts = [];

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('yyyy/MM/dd HH:mm').format(timestamp);
  }

  @override
  void initState() {
    super.initState();
    _postsRef =
        FirebaseDatabase.instance.ref().child('boards/${widget.boardName}');
    Query orderedPostsQuery = _postsRef.orderByChild('timestamp');
    orderedPostsQuery.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> postsMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Post> postsList = postsMap.entries.map((entry) {
          return Post.fromMap(Map<String, dynamic>.from(entry.value));
        }).toList();
        postsList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        setState(() {
          _posts = postsList;
        });
      } else {
        setState(() {
          _posts = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0a559c),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          widget.boardName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _posts.isEmpty
                ? Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      '게시판이 비어있습니다.\n첫 글을 작성해보세요!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentDetailScreen(
                                  postId: _posts[index].postId,
                                  boardName: widget.boardName,
                                ),
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          title: Text(
                            _posts[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _posts[index].content,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    formatTimestamp(_posts[index].timestamp),
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0a559c),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WritingScreen(boardName: widget.boardName),
                  ),
                );
              },
              child: const Text(
                '글 쓰기',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
