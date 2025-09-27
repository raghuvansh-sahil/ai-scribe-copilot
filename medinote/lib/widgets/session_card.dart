import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medinote/models/session.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final bool showFull;

  const SessionCard({super.key, required this.session, required this.showFull});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(
      session.startTime.toLocal(),
    );
    final formattedTime = DateFormat.Hm().format(session.startTime.toLocal());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Text(
                    session.sessionTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  formattedTime,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  session.id,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            if (showFull) ...[
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: 12),
              Text(
                session.sessionSummary,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
