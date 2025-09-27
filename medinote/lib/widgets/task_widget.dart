import 'package:flutter/material.dart';

class Task {
  int taskId;
  String label;
  bool complete;

  Task({required this.taskId, required this.label, this.complete = false});
}

class TaskWidget extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  const TaskWidget({
    super.key,
    required this.label,
    required this.onDelete,
    required this.onComplete,
  });

  Widget _buildDismissibleBackground({
    required Color color,
    required IconData icon,
    FractionalOffset align = FractionalOffset.centerLeft,
  }) {
    return Container(
      height: 42.0,
      color: color,
      child: Align(
        alignment: align,
        child: Icon(icon, color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.0,
      child: Dismissible(
        key: Key(label),
        direction: DismissDirection.horizontal,
        background: _buildDismissibleBackground(
          color: Colors.lime,
          icon: Icons.check,
        ),
        secondaryBackground: _buildDismissibleBackground(
          color: Colors.red,
          icon: Icons.delete,
          align: FractionalOffset.centerRight,
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onComplete();
          } else {
            onDelete();
          }
        },
        child: Align(
          alignment: FractionalOffset.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
