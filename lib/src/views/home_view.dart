import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:easy_screen_recorder/src/views/trimmer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool onStartRecording = false;
  bool recording = false;

  CountDownController _recordingTimerController = CountDownController();
  int _duration = 4;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Screen Recorder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !recording
              ? onStartRecording
                  ? onStartRecordingTimer(
                      _duration,
                      _recordingTimerController,
                      () {
                        print('Timer has started');
                      },
                      () {
                        print('Timer has finished');
                        startScreenRecord(false);
                      },
                    )
                  : Center(
                      child: ElevatedButton(
                        child: Text('Record screen'),
                        onPressed: () => setState(() {
                          onStartRecording = !onStartRecording;
                        }),
                      ),
                    )
              : Center(
                  child: ElevatedButton(
                    child: Text("Stop"),
                    onPressed: () => stopScreenRecord(),
                  ),
                )
        ],
      ),
    );
  }

  startScreenRecord(bool audio) async {
    bool start = false;
    await Future.delayed(const Duration(milliseconds: 1000));

    start = await FlutterScreenRecording.startRecordScreen(
        DateTime.now().toIso8601String(),
        titleNotification: "ESC has began!",
        messageNotification: "recording...",
        iconNotification: "ic_stat_hot_tub");

    setState(() {
      onStartRecording = !onStartRecording;
      if (start) recording = !recording;
    });

    return start;
  }

  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
    });
    print("Open result video with trimmer");
    if (path.isNotEmpty) {
      File file = File(path);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return TrimmerView(file);
        }),
      );
    } else {
      print('VideoSaver failed');
    }
  }

  Widget onStartRecordingTimer(
    int duration,
    CountDownController _controller,
    Function onStart,
    Function onComplete,
  ) {
    return Center(
        child: CircularCountDownTimer(
      // Countdown duration in Seconds.
      duration: _duration,

      // Countdown initial elapsed Duration in Seconds.
      initialDuration: 0,

      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
      controller: _controller,

      // Width of the Countdown Widget.
      width: MediaQuery.of(context).size.width / 2,

      // Height of the Countdown Widget.
      height: MediaQuery.of(context).size.height / 2,

      // Ring Color for Countdown Widget.
      ringColor: Colors.grey[300],

      // Ring Gradient for Countdown Widget.
      ringGradient: null,

      // Filling Color for Countdown Widget.
      fillColor: Colors.lightGreen[100],

      // Filling Gradient for Countdown Widget.
      fillGradient: null,

      // Background Color for Countdown Widget.
      backgroundColor: Colors.lightGreen[500],

      // Background Gradient for Countdown Widget.
      backgroundGradient: null,

      // Border Thickness of the Countdown Ring.
      strokeWidth: 20.0,

      // Begin and end contours with a flat edge and no extension.
      strokeCap: StrokeCap.round,

      // Text Style for Countdown Text.
      textStyle: TextStyle(
          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),

      // Format for the Countdown Text.
      textFormat: CountdownTextFormat.S,

      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
      isReverse: true,

      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
      isReverseAnimation: true,

      // Handles visibility of the Countdown Text.
      isTimerTextShown: true,

      // Handles the timer start.
      autoStart: true,

      // This Callback will execute when the Countdown Starts.
      onStart: onStart,

      // This Callback will execute when the Countdown Ends.
      onComplete: onComplete,
    ));
  }
}
