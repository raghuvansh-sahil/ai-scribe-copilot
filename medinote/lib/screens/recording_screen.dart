import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/models/recording_session.dart';
import 'package:medinote/services/api_service.dart';

class RecordingScreen extends StatefulWidget {
  final Patient patient;
  final String userId;

  const RecordingScreen({
    super.key,
    required this.patient,
    required this.userId,
  });

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool _isLoading = false;
  String? _sessionId;

  Future<void> _startSession() async {
    setState(() => _isLoading = true);

    try {
      final sessionRequest = RecordingSessionRequest(
        patientId: widget.patient.id ?? '',
        userId: widget.userId,
        patientName: widget.patient.name,
        status: "recording",
        startTime: DateTime.now(),
        templateId: "new_patient_visit",
      );

      final response = RecordingSessionResponse(id: "session_789");

      setState(() => _sessionId = response.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Recording session started: ${response.id}")),
      );

      // TODO: Start actual recording using RecordingService here
      // RecordingService.instance.startRecording(response.id);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to start session: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Start Session - ${widget.patient.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_sessionId != null)
              Text(
                "Session ID: $_sessionId",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _startSession,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Start Recording Session"),
            ),
          ],
        ),
      ),
    );
  }
}
