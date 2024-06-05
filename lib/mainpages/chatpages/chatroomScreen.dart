import 'package:everytime/mainpages/chatpages/sendchatScreen.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class ChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("익명"),
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_rounded)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendChatScreen()),
                  );
                },
                icon: Icon(Icons.send_rounded)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded))
          ],
        ),
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    index % 2 == 0
                        ? Text(
                            "보낸 쪽지",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "받은 쪽지",
                            style: TextStyle(
                                color: Colors.cyan,
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
