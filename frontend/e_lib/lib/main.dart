import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookDetail(),
    );
  }
}
