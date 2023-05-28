import 'package:flutter/material.dart';
import '../screens/loading.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Wallet Demo',
      theme: ThemeData(
          fontFamily: 'spoqaFont',
          primaryColor: Colors.blueGrey,
          primarySwatch: Colors.blueGrey,
          textTheme: TextTheme(
            headline1: TextStyle(color: Colors.white),
            headline2: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white,
            fontSize: 14,)
          )
      ),
      home: Loading(),
    );
  }
}