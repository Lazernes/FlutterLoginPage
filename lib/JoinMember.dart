import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:login_page/SignIn.dart';

class JoinMember extends StatefulWidget {
  @override
  _JoinMemberState createState() => _JoinMemberState();
}

class _JoinMemberState extends State<JoinMember> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();


  Future<void> _Join(String id, String password, String name, String phoneNum) async {
    final url = Uri.parse('http://10.0.2.2:8081/api/member');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password, 'name': name, 'phoneNum': phoneNum}),
    );

    if(response.statusCode == 200) {
      print('Signup succesful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> SignIn()),
      );
    } else {
      print('Signup failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입, 나중에 이 Text 삭제 예정'),
      ),
      body: Padding(padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10.0),
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: "아이디"
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: "비밀번호"
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: "이름"
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _phoneNumController,
            decoration: InputDecoration(
                labelText: "전화번호"
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(onPressed: () {
            _Join(_idController.text, _passwordController.text, _nameController.text, _phoneNumController.text);
          }, child: Text('회원가입'),)
        ],
      )),
    );
  }

}

