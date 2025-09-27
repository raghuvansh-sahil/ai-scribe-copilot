import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medinote/models/session.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final bool showFull;

  const SessionCard({super.key, required this.session, required this.showFull});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(session.date);
    final formattedTime = DateFormat.Hm().format(session.startTime.toLocal());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              session.sessionTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(formattedDate), Text(session.id)],
            ),
            if (showFull) ...[
              const Divider(thickness: 1),
              Text(
                session.sessionSummary,
                textAlign: TextAlign.justify,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Start Time'), Text(formattedTime)],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
