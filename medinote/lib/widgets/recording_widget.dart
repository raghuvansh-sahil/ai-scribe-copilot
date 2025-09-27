import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medinote/services/speech_service.dart';

class RecordingWidget extends StatefulWidget {
  const RecordingWidget({super.key});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  bool isRecording = false;
  double micLevel = 0.0; // real-time audio level (0.0 to 1.0)
  StreamSubscription<dynamic>? _micSubscription;

  static const MethodChannel _channel = MethodChannel(
    'com.example.medinote/speech',
  );

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  @override
  void dispose() {
    _micSubscription?.cancel();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (!isRecording) {
      try {
        await SpeechService.startRecording();
        HapticFeedback.mediumImpact();
      } on PlatformException catch (e) {
        debugPrint('Error starting recording: $e');
      }
    } else {
      try {
        await SpeechService.stopRecording();
        HapticFeedback.selectionClick();
        setState(() => micLevel = 0.0);
      } on PlatformException catch (e) {
        debugPrint('Error stopping recording: $e');
      }
    }

    setState(() => isRecording = !isRecording);
  }

  Future<void> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'micLevel':
        // This comes from native code with audio level between 0.0 - 1.0
        final level = call.arguments as double;
        if (mounted) setState(() => micLevel = level);
        break;
      case 'onSpeechChunk':
        // Optional: send chunk to backend here
        final chunkData = call.arguments as Uint8List;
        debugPrint('Chunk received: ${chunkData.length} bytes');
        break;
      default:
        debugPrint('Unknown method call from native: ${call.method}');
    }
  }

  void _playAudio() => SpeechService.startPlaying();
  void _stopAudio() => SpeechService.stopPlaying();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isRecording
                          ? [Colors.red.withOpacity(0.5), Colors.red]
                          : [Colors.green.withOpacity(0.3), Colors.green],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleRecording,
                icon: Icon(isRecording ? Icons.stop : Icons.mic, size: 40),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Playback buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _playAudio, child: const Text("Play")),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: _stopAudio, child: const Text("Stop")),
            ],
          ),
        ],
      ),
    );
  }
}
