import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:open_file/open_file.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool recording = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Screen Recording'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !recording
              ? Center(
                  child: ElevatedButton(
                    child: Text("Record Screen"),
                    onPressed: () => startScreenRecord(false),
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    child: Text("Stop Record"),
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

    start = await FlutterScreenRecording.startRecordScreen("Title",
        titleNotification: "dsffad", messageNotification: "sdffd");

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