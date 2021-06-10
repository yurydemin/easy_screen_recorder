import 'package:easy_screen_recorder/src/views/home_view.dart';
import 'package:flutter/material.dart';

class EasyScreenRecorderApp extends StatefulWidget {
  @override
  _EasyScreenRecorderAppState createState() => _EasyScreenRecorderAppState();
}

class _EasyScreenRecorderAppState extends State<EasyScreenRecorderApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
