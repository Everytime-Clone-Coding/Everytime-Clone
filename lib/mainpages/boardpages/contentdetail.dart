import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:everytime/database_structure/post.dart';
import 'package:everytime/database_structure/comment.dart';
import 'package:intl/intl.dart';
// ignore_for_file: prefer_const_constructors

class ContentDetailScreen extends StatefulWidget {
  final String boardName;
  final String postId;

  const ContentDetailScreen(
      {super.key, required this.boardName, required this.postId});

  @override
  _ContentDetailScreenState createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  late DatabaseReference _postsRef;
  late Query _commentsQuery;
  Post? _posts;
  List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  late String userId;

  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    } else {
      userId = 'unknown';
    }

    _postsRef = FirebaseDatabase.instance
        .ref()
        .child('boards/${widget.boardName}/${widget.postId}');
    _commentsQuery = FirebaseDatabase.instance
        .ref()
        .child('boards/${widget.boardName}/${widget.postId}/comments')
        .orderByChild('timestamp');

    _postsRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> postData =
            event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _posts = Post.fromMap(Map<String, dynamic>.from(postData));
        });
      } else {
        setState(() {
          _posts = null;
        });
      }
    });

    _commentsQuery.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        List<Comment> comments = [];
        Map<dynamic, dynamic> commentsData =
            event.snapshot.value as Map<dynamic, dynamic>;
        commentsData.forEach((key, value) {
          comments.add(Comment.fromMap(Map<String, dynamic>.from(value)));
        });
        comments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        setState(() {
          _comments = comments;
        });
      } else {
        setState(() {
          _comments = [];
        });
      }
    });
  }

  void _incrementLikes() async {
    if (_posts != null && !_posts!.likedBy.contains(userId)) {
      setState(() {
        _posts!.likes++;
        _posts!.likedBy.add(userId);
      });
      await _postsRef.update({
        'likes': _posts!.likes,
        'likedBy': _posts!.likedBy,
      });
    } else {
      _showAlreadyLikedDialog();
    }
  }

  void _showAlreadyLikedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text("이미 공감한 글입니다."),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pushScrap() async {
    if (_posts != null && !_posts!.scrapedBy.contains(userId)) {
      setState(() {
        _posts!.scraped++;
        _posts!.scrapedBy.add(userId);
      });
      await _postsRef.update({
        'scraped': _posts!.scraped,
        'scrapedBy': _posts!.scrapedBy,
      });
    } else {
      _showAlreadyScrapedDialog();
    }
  }

  void _showAlreadyScrapedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text("이미 스크랩한 글입니다."),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSubmitted(String value) async {
    if (value.isNotEmpty) {
      DatabaseReference newCommentRef = _commentsQuery.ref.push();
      String commentId = newCommentRef.key!;
      Comment newComment = Comment(
        commentId: commentId,
        content: value,
        timestamp: DateTime.now(),
        userId: userId,
      );
      await newCommentRef.set(newComment.toMap());
      _commentController.clear();
    }
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('yyyy/MM/dd HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(children: <Widget>[
                Icon(
                  Icons.portrait_rounded,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "익명의 단곰이",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _posts != null
                        ? Text(
                            formatTimestamp(_posts!.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _posts != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _posts!.title ?? 'No Title',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          _posts!.content ?? 'No Content',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 12,
                    color: Colors.red,
                  ),
                  Text(
                    _posts != null ? _posts!.likes.toString() : '0',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 11,
                    color: Colors.greenAccent,
                  ),
                  Text(
                    _comments.length.toString(),
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.star_border_rounded,
                    size: 15,
                    color: Colors.yellow[600],
                  ),
                  Text(
                    _posts != null ? _posts!.scraped.toString() : '0',
                    style: TextStyle(
                      color: Colors.yellow[600],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed: _incrementLikes,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite_outline_rounded,
                          color: Colors.grey,
                          size: 10,
                        ),
                        Text(
                          "공감",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  TextButton(
                    onPressed: _pushScrap,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star_border_rounded,
                          color: Colors.grey,
                          size: 10,
                        ),
                        Text(
                          "스크랩",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.portrait_rounded,
                                size: 30,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(width: 3,),
                              Text(
                                "익명의 단곰이",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(_comments[index].content),
                        trailing: Text(
                          formatTimestamp(_comments[index].timestamp),
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      );
                    },
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  //   child: TextFormField(
                  //   controller: _commentController,
                  //   decoration: InputDecoration(
                  //     hintText: '댓글을 입력하세요.',
                  //     hintStyle: TextStyle(color: Colors.grey),
                  //     filled: true,
                  //     fillColor: Colors.grey.shade200,
                  //     enabledBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.grey.shade200),
                  //     ),
                  //   ),
                  //   onFieldSubmitted: _onSubmitted,
                  // ),),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.grey.shade200,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요.',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: false,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      onFieldSubmitted: _onSubmitted,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.grey,
                  onPressed: () => _onSubmitted(_commentController.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
