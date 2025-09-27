import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/models/session.dart';
import 'package:medinote/screens/recording_screen.dart';
import 'package:medinote/services/api_service.dart';
import 'package:medinote/widgets/session_card.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;
  final String userId;

  const PatientScreen({super.key, required this.patient, required this.userId});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final Set<int> expandedSessions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.patient.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(widget.patient.id ?? '', style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordingScreen(
                patient: widget.patient,
                userId: widget.userId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<Session>>(
          future: ApiServiceHandler.instance.getPatientSessions(
            patientId: widget.patient.id ?? '',
          ),
          builder: (context, AsyncSnapshot<List<Session>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData && snapshot.data != null) {
              final sessions = snapshot.data!;
              if (sessions.isEmpty) {
                return const Center(child: Text('No sessions saved.'));
              }
              return ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final isExpanded = expandedSessions.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedSessions.remove(index);
                        } else {
                          expandedSessions.add(index);
                        }
                      });
                    },
                    child: SessionCard(
                      session: sessions[index],
                      showFull: isExpanded,
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Nothing to show.'));
            }
          },
        ),
      ),
    );
  }
}
