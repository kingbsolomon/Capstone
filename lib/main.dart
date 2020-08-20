import 'package:flutter/material.dart';
import 'package:login_test/helper/authenticate.dart';
import 'package:login_test/views/signin.dart';
import 'package:login_test/views/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xff1F1F1F),
      ),
      home: Authenticate(),
    );
  }
}

