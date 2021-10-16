import 'package:ec_task/screens/home_screen.dart';
import 'package:ec_task/util/values/strings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.kAppTitle,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
