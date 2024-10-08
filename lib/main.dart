import 'package:flutter/material.dart';
import 'package:login_page/HomeScreen.dart';
import 'package:login_page/MyPage.dart';
import 'package:login_page/Navigation.dart';
import 'package:login_page/SignIn.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/infra_info': (context) => MyPage(),
        '/navigator': (context) => SignIn(),
        '/message': (context) => Navigation()
      },
    );
  }
}
