import 'dart:convert';

import 'package:login_page/token_storage.dart';

import 'widget/CommonScaffold.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyPage extends StatefulWidget{
  //const Member({Key? key}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();  // 페이지 로드 시 사용자 정보 가져오기
  }

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();

    if(jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8081/api/member/info'),
        headers: {
          'Authorization' : 'Bearer $jwtToken',
        },
      );

      if(response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          userName = userData['name'] ?? 'Unknown'; // name이 null이면 'Unknown'
          userPhone = userData['phoneNum'] ?? 'No phone';
        });
      } else {
        print("Failed to load user info: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT Token is missing");
    }

  }

  Future<void> logout() async {
    // JWT 토큰 가져오기
    String? jwtToken = await getJwtToken();

    if(jwtToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8081/logout'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if(response.statusCode == 200) {
        // 로그아웃 성공 시 JWT 토큰 삭제
        await removeJwtToken();

        // 로그아웃 시 로그인 페이지로 이동
        Navigator.pushReplacementNamed(context, '/navigator');
      } else if(response.statusCode == 302) { // 302 에러
        var redirectUrl = response.headers['location'];
        if(redirectUrl != null) {
          print("Redirecting to: $redirectUrl");
          Navigator.pushReplacementNamed(context, '/navigator');
        }
      } else {
        print("Failed to logout: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT Token is missing");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: Text("내 정보"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffD9D9D9),
            ),
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 400,
                  height: 55,
                  // margin: EdgeInsets.only(right: .0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 5.0,),
                      Text(
                        userName.isNotEmpty ? userName : '이름을 불러오는 중...',
                        style: TextStyle(fontSize: 16.0,),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        userPhone.isNotEmpty ? userPhone : '전화번호흫 불러오는 중...',
                        style: TextStyle(fontSize: 11.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.yellow,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // 첫 번째 버튼 동작
                        },
                        child: Text('개인정보수정',
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.yellow,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // 두 번째 버튼 동작
                          logout();
                        },
                        child: Text('로그아웃',
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}