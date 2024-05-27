import 'package:everytime/mainpages/boardpages/contentdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:everytime/database_structure/post.dart';
// ignore_for_file: prefer_const_constructors

class MyWriteScreen extends StatefulWidget {
  const MyWriteScreen({super.key});
  _MyWriteScreenState createState() => _MyWriteScreenState();
}

class _MyWriteScreenState extends State<MyWriteScreen> {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref().child('boards/');
  late String userId;
  List<Post> _myPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchMyPosts();
  }

  Future<void> _fetchMyPosts() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        userId = auth.currentUser!.uid;
        DataSnapshot snapshot = await _postsRef.once() as DataSnapshot; // 수정된 부분
        if (snapshot.value != null) {
          Map<dynamic, dynamic> postsMap = snapshot.value as Map<dynamic, dynamic>;
          List<Post> postsList = [];
          postsMap.forEach((key, value) {
            Post post = Post.fromMap(Map<String, dynamic>.from(value));
            if (post.userId == userId) {
              postsList.add(post);
            }
          });
          postsList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          setState(() {
            _myPosts = postsList;
          });
        }
      }
    } catch (error) {
      print('Error fetching my posts: $error');
    }
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
          "내가 쓴 글",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _myPosts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_myPosts[index].title),
            subtitle: Text(_myPosts[index].content),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentDetailScreen(
                    postId: _myPosts[index].postId,
                    boardName: _myPosts[index].boardName,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}