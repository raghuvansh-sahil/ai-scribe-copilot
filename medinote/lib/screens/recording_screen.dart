import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/models/recording_session.dart';
import 'package:medinote/services/api_service.dart';
import 'package:medinote/widgets/recording_widget.dart';

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
  String? sessionId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    setState(() => isLoading = true);

    try {
      final Future<RecordingSessionResponse> responseFuture = ApiServiceHandler
          .instance
          .uploadSession(
            RecordingSessionRequest(
              patientId: widget.patient.id ?? '',
              userId: widget.userId,
              patientName: widget.patient.name,
              status: "recording",
              startTime: DateTime.now(),
              templateId: "new_patient_visit",
            ),
          );

      final RecordingSessionResponse response = await responseFuture;

      setState(() {
        sessionId = response.id;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to start session: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Record - ${widget.patient.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : const RecordingWidget(),
      ),
    );
  }
}
