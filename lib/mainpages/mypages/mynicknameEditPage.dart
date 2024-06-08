import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'mypageProvider.dart';

class MyNicknameEditPage extends StatelessWidget {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var nowNickname = Provider.of<MyPageProvider>(context).nickname;

    return Scaffold(
      appBar: AppBar(
        title: const Text("닉네임 변경"),
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        backgroundColor: Colors.white,
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                maxLength: 8,
                decoration: InputDecoration(hintText: "현재 닉네임: ${nowNickname}"),
                // 영문, 한글만 입력
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[a-z A-Z ㄱ-ㅎ|가-힣|·|：]'))
                ],
                validator: (value) {
                  if (value!.length == 0) {
                    return "최소 1글자 이상 입력해주세요";
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<MyPageProvider>(context, listen: false)
                      .changeNickname(_textController.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "변경",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}
