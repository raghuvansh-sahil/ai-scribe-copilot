import 'package:flutter/material.dart';
import 'package:medinote/services/speech_service.dart';

class RecordingWidget extends StatefulWidget {
  const RecordingWidget({super.key});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () async {
            if (!isRecording) {
              await SpeechService.startRecording();
            } else {
              await SpeechService.stopRecording();
            }
            setState(() => isRecording = !isRecording);
          },
          backgroundColor: isRecording ? Colors.red : Colors.green,
          child: Icon(isRecording ? Icons.stop : Icons.mic),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => SpeechService.startPlaying(),
              child: const Text("Play"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => SpeechService.stopPlaying(),
              child: const Text("Stop"),
            ),
          ],
        ),
      ],
    );
  }
}
