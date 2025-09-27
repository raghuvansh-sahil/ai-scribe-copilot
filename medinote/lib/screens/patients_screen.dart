import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/models/session.dart';
import 'package:medinote/widgets/session_card.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;

  const PatientScreen({super.key, required this.patient});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final Set<int> expandedSessions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.patient.name)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  widget.patient.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.patient.id, style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Session>>(
                future: NetworkHandler.getReceipts(),
                builder: (context, AsyncSnapshot<List<Session>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
          ],
        ),
      ),
    );
  }
}
