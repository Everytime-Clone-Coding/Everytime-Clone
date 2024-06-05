import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

class SendChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("쪽지 보내기"),
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.clear)),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text(
                  "전송",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: TextFormField(
          decoration: InputDecoration(hintText: "쪽지 내용을 입력하세요"),
          minLines: null,
          maxLines: 999,
          validator: (value) {
            if (value!.isEmpty) {
              return "쪽지 내용을 입력해주세요.";
            }
            return null;
          },
        ));
  }
}
