import 'package:flutter/services.dart';

class SpeechService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.medinote/speech',
  );

  static Future<void> startRecording() async {
    try {
      await _channel.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      print("Failed to start recording service: '${e.message}'.");
    }
  }

  static Future<void> stopRecording() async {
    try {
      await _channel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      print("Failed to stop recording service: '${e.message}'.");
    }
  }

  static Future<void> startPlaying() async {
    await _channel.invokeMethod('startPlaying');
  }

  static Future<void> stopPlaying() async {
    await _channel.invokeMethod('stopPlaying');
  }
}
