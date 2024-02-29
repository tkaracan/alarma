import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundSelectionPage extends StatelessWidget {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<String> sounds = ['simple_alarm.wav', 'morse_like_alarm.wav']; // Add more sound file names as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Alarm Sound'),
      ),
      body: ListView.builder(
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Sound ${index + 1}'),
            onTap: () {
              Navigator.pop(context, sounds[index]); // Return the selected sound to the previous screen
            },
          );
        },
      ),
    );
  }
}
