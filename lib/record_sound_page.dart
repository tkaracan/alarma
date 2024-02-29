import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordSoundPage extends StatefulWidget {
  @override
  _RecordSoundPageState createState() => _RecordSoundPageState();
}

class _RecordSoundPageState extends State<RecordSoundPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  Duration _duration = Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  void _initRecorder() async {
    final status = await Permission.microphone.request();
    print(PermissionStatus.granted);
    if (status != PermissionStatus.granted) {
      // Handle permissions not granted
      return;
    }
    await _recorder.openRecorder();
  }

  void _startRecording() async {
    await _recorder.startRecorder(
      toFile: 'my_alarm_sound.wav',
      codec: Codec.aacADTS,
    );
    _startTimer();
    setState(() => _isRecording = true);
  }

  void _stopRecording() async {
    await _recorder.stopRecorder();
    _stopTimer();
    setState(() => _isRecording = false);
    // Return to previous screen with path of the recorded sound
    Navigator.pop(context, 'my_alarm_sound.wav');
  }

  void _startTimer() {
    _duration = Duration();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
      if (_duration.inMinutes == 5) { // Stop recording after 5 minutes
        _stopRecording();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Sound'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              onPressed: () {
                if (_isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
