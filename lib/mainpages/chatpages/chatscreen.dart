import 'package:everytime/mainpages/chatpages/chatroomScreen.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("쪽지"),
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatRoomScreen()),
                  );
                },
                title: Row(
                  children: [
                    Text(
                      "익명",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text("24/03/05 11:22",
                        style: TextStyle(color: Colors.black38, fontSize: 12))
                  ],
                ),
                subtitle: Text(
                  "테스트 쪽지 ${index}",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              );
            }));
  }
}