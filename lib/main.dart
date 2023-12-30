import 'package:flutter/material.dart';
import 'package:phonecallprice/Pages/Go.dart';
import 'package:phonecallprice/Pages/HomePage.php.dart';
import 'package:phonecallprice/Pages/Login.dart';
import 'package:phonecallprice/Pages/Register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Go(),
    );
  }
}