import 'package:everytime/mainpages/boardpages/contentdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:everytime/database_structure/post.dart';
import 'package:everytime/database_structure/user.dart' as EverytimeUser;

class MyWriteScreen extends StatefulWidget {
  const MyWriteScreen({super.key});
  _MyWriteScreenState createState() => _MyWriteScreenState();
}

class _MyWriteScreenState extends State<MyWriteScreen> {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref().child('posts');
  final DatabaseReference _userInfoRef = FirebaseDatabase.instance.ref().child('users');

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
        DataSnapshot snapshot = await _userInfoRef.child(userId).once() as DataSnapshot; // 수정된 부분
        if (snapshot.value != null) {
          EverytimeUser.UserInfo userInfo = EverytimeUser.UserInfo.fromMap(snapshot.value as Map<String, dynamic>); // 수정된 부분
          List<String> userPosts = userInfo.posts;
          List<Post> postsList = [];
          for (String postId in userPosts) {
            DataSnapshot postSnapshot = await _postsRef.child(postId).once() as DataSnapshot; // 수정된 부분
            if (postSnapshot.value != null) {
              Map<String, dynamic> postData = postSnapshot.value as Map<String, dynamic>;
              Post post = Post.fromMap(postData);
              postsList.add(post);
            }
          }
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "내가 쓴 글",
          style: TextStyle(color: Colors.white),
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