import 'package:flutter/services.dart';

class SpeechService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.medinote/speech',
  );

  static Future startRecording() async {
    await _channel.invokeMethod('startRecording');
  }

  static Future stopRecording() async {
    await _channel.invokeMethod('stopRecording');
  }

  static Future startPlaying() async {
    await _channel.invokeMethod('startPlaying');
  }

  static Future stopPlaying() async {
    await _channel.invokeMethod('stopPlaying');
  }
}
