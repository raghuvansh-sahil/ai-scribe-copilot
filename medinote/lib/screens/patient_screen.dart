import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/screens/recording_screen.dart';
import 'package:medinote/widgets/session_card.dart';
import 'package:provider/provider.dart';
import 'package:medinote/providers/session_provider.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;
  final String userId;

  const PatientScreen({super.key, required this.patient, required this.userId});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSessions(widget.patient.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.patient.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              widget.patient.id ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
        child: const Icon(Icons.add, size: 28),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SessionProvider>(
          builder: (context, sessionProvider, child) {
            if (sessionProvider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading sessions...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            if (sessionProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading sessions',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        sessionProvider.loadSessions(widget.patient.id ?? '');
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final sessions = sessionProvider.getSessions(
              widget.patient.id ?? '',
            );
            if (sessions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.record_voice_over,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No sessions yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to start recording',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final isExpanded = sessionProvider.isExpanded(session.id);

                return GestureDetector(
                  onTap: () {
                    sessionProvider.toggleSessionExpansion(session.id);
                  },
                  child: SessionCard(session: session, showFull: isExpanded),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
