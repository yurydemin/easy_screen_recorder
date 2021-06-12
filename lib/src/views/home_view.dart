import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool recording = false;

  requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
      Permission.microphone,
      Permission.mediaLibrary,
    ].request();
    print(statuses);
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Foreground Service Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text("START"),
                onPressed: () {
                  startForegroundService();
                },
              ),
              ElevatedButton(
                child: Text("STOP"),
                onPressed: () async {
                  await FlutterForegroundPlugin.stopForegroundService();
                },
              ),
              ElevatedButton(
                child: Text("Force Crash"),
                onPressed: () {
                  exit(1);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Flutter Screen Recording'),
  //     ),
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         !recording
  //             ? Center(
  //                 child: ElevatedButton(
  //                   child: Text("Record Screen"),
  //                   onPressed: () => startScreenRecord(false),
  //                 ),
  //               )
  //             : Center(
  //                 child: ElevatedButton(
  //                   child: Text("Stop Record"),
  //                   onPressed: () => stopScreenRecord(),
  //                 ),
  //               )
  //       ],
  //     ),
  //   );
  // }

  void startForegroundService() async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
    //await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: () {
        print("Foreground on Started");
      },
      onStopped: () {
        print("Foreground on Stopped");
      },
      title: "Flutter Foreground Service",
      content: "This is Content",
      iconName: "ic_stat_hot_tub",
    );
  }

  void globalForegroundService() {
    print("current datetime is ${DateTime.now()}");
  }

  startScreenRecord(bool audio) async {
    bool start = false;
    await Future.delayed(const Duration(milliseconds: 1000));

    start = await FlutterScreenRecording.startRecordScreen(
        DateTime.now().toIso8601String(),
        titleNotification: "STARTED",
        messageNotification: "MESSAGE");

    if (start) {
      setState(() => recording = !recording);
    }

    return start;
  }

  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
    });
    print("Opening video");
    print(path);
    OpenFile.open(path);
  }
}
