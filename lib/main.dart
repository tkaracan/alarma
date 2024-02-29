import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sound_selection_page.dart'; 
import 'record_sound_page.dart'; // Make sure this import matches the location of your RecordSoundPage file


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlarmPage(),
    );
  }
}

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay? _alarmTime;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _selectedSound = 'simple_alarm.wav'; // Default sound

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _checkTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkTime() {
    final now = DateTime.now();
    if (_alarmTime != null &&
        now.hour == _alarmTime!.hour &&
        now.minute == _alarmTime!.minute) {
      _playSound();
      // To prevent the sound from playing repeatedly every minute.
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Alarm'),
          content: Text('Alarm is ringing!'),
          actions: [
            TextButton(
              onPressed: () {
                _audioPlayer.stop();
                Navigator.of(context).pop();
              },
              child: Text('Stop Alarm'),
            ),
          ],
        ),
      );
      _alarmTime = null;
    }
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('audio/$_selectedSound'));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _alarmTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _alarmTime) {
      setState(() {
        _alarmTime = picked;
      });
    }
  }

  Future<void> _selectSound(BuildContext context) async {
    final String? selectedSound = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SoundSelectionPage()),
    );
    if (selectedSound != null) {
      setState(() {
        _selectedSound = selectedSound;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/whitenoise.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _alarmTime != null
                    ? 'Alarm set for ${_alarmTime!.format(context)}'
                    : 'No alarm set',
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('Set Alarm'),
              ),
                            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RecordSoundPage()),
                  );
                },
                child: Text('Record New Sound'),
              ),
              ElevatedButton(
                onPressed: () => _selectSound(context),
                child: Text('Select Alarm Sound'),
              ),
              ElevatedButton(
                onPressed: () => _audioPlayer.play(AssetSource('audio/$_selectedSound')),
                child: Text('Test Sound'),
              ),
              ElevatedButton(
                onPressed: () => _audioPlayer.stop(),
                child: Text('Stop Sound'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
