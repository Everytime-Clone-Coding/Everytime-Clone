import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:everytime/database_structure/post.dart';
import 'package:everytime/database_structure/user.dart';
// ignore_for_file: prefer_const_constructors

class WritingScreen extends StatefulWidget {
  final String boardName;

  const WritingScreen({super.key, required this.boardName});

  @override
  _WritingScreenState createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  String postId = '';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  int likes = 0;
  int scraped = 0;

  void _submitPost() async {
    if (_formKey.currentState?.validate() ?? false) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DatabaseReference newPostRef = _databaseRef.child('boards/${widget.boardName}').push();
        postId = newPostRef.key ?? '';

        Post newPost = Post(
          postId: postId,
          userId: user.email ?? 'Anonymous',
          title: _titleController.text,
          content: _contentController.text,
          timestamp: DateTime.now(),
          boardName: widget.boardName,
          likes: likes,
          scraped: scraped,
        );

        await newPostRef.set(newPost.toMap());

        DatabaseReference userRef = _databaseRef.child('users/${user.uid}');
        DataSnapshot userData = await userRef.once(); // 여기서 발생한 오류가 있었습니다.
        if (userData.value != null) {
          Map<String, dynamic> userDataMap = userData.value;
          List<String> userPosts = List<String>.from(userDataMap['posts'] ?? []);
          userPosts.add(postId);
          await userRef.child('posts').set(userPosts);
        } else {
          await userRef.set({
            'userId': user.uid,
            'posts': [postId],
            'comments': [],
            'scraps': [],
          });
        }

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('글 쓰기'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff0a559c),
                ),
                onPressed: _submitPost,
                child: const Text(
                  "저장",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ]),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  hintText: '제목',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400), // 아래쪽 테두리 색상 설정
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                  hintText: '내용을 입력하세요.',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력하세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
