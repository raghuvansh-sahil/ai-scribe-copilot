import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medinote/data/languages.dart';
import 'package:medinote/services/speech_recognizer.dart';
import 'package:medinote/widgets/task_widget.dart';

class TranscriptorWidget extends StatefulWidget {
  final Language lang;

  const TranscriptorWidget({super.key, required this.lang});

  @override
  State<TranscriptorWidget> createState() => _TranscriptorWidgetState();
}

class _TranscriptorWidgetState extends State<TranscriptorWidget> {
  String transcription = '';
  bool authorized = false;
  bool isListening = false;
  List<Task> todos = [];

  bool get isNotEmpty => transcription.isNotEmpty;
  int get numArchived => todos.where((t) => t.complete).length;
  Iterable<Task> get incompleteTasks => todos.where((t) => !t.complete);

  @override
  void initState() {
    super.initState();
    SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
    _activateRecognition();
  }

  @override
  void dispose() {
    if (isListening) _cancelRecognitionHandler();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> blocks = [
      Expanded(
        flex: 2,
        child: ListView(
          children: incompleteTasks
              .map(
                (t) => _buildTaskWidgets(
                  task: t,
                  onDelete: () => _deleteTaskHandler(t),
                  onComplete: () => _completeTaskHandler(t),
                ),
              )
              .toList(),
        ),
      ),
      _buildButtonBar(),
    ];

    if (isListening || transcription.isNotEmpty) {
      blocks.insert(
        1,
        _buildTranscriptionBox(
          text: transcription,
          onCancel: _cancelRecognitionHandler,
          width: size.width - 20.0,
        ),
      );
    }

    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: blocks),
    );
  }

  void _saveTranscription() {
    if (transcription.isEmpty) return;
    setState(() {
      todos.add(
        Task(
          taskId: DateTime.now().millisecondsSinceEpoch,
          label: transcription,
        ),
      );
      transcription = '';
    });
    _cancelRecognitionHandler();
  }

  Future<void> _startRecognition() async {
    final res = await SpeechRecognizer.start(widget.lang.code);
    if (!res) {
      showDialog(
        context: context,
        builder: (_) => const SimpleDialog(
          title: Text("Error"),
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Recognition not started'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _cancelRecognitionHandler() async {
    final res = await SpeechRecognizer.cancel();
    setState(() {
      transcription = '';
      isListening = res;
    });
  }

  Future<void> _activateRecognition() async {
    final res = await SpeechRecognizer.activate();
    setState(() => authorized = res);
  }

  Future<void> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onSpeechAvailability":
        setState(() => isListening = call.arguments);
        break;
      case "onSpeech":
        if (todos.isNotEmpty && transcription == todos.last.label) return;
        setState(() => transcription = call.arguments);
        break;
      case "onRecognitionStarted":
        setState(() => isListening = true);
        break;
      case "onRecognitionComplete":
        setState(() {
          if (todos.isEmpty) {
            transcription = call.arguments;
          } else if (call.arguments == todos.last.label) {
            transcription = ''; // already saved
          } else {
            transcription = call.arguments;
          }
        });
        break;
      default:
        debugPrint('Unknown method ${call.method}');
    }
  }

  void _deleteTaskHandler(Task t) {
    setState(() {
      todos.remove(t);
      _showStatus("cancelled");
    });
  }

  void _completeTaskHandler(Task completed) {
    setState(() {
      todos = todos
          .map((t) => completed == t ? (t..complete = true) : t)
          .toList();
      _showStatus("completed");
    });
  }

  Widget _buildButtonBar() {
    List<Widget> buttons = [
      !isListening
          ? _buildIconButton(
              authorized ? Icons.mic : Icons.mic_off,
              authorized ? _startRecognition : null,
              color: Colors.white,
              fab: true,
            )
          : _buildIconButton(
              Icons.add,
              isListening ? _saveTranscription : null,
              color: Colors.white,
              backgroundColor: Colors.greenAccent,
              fab: true,
            ),
    ];
    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  Widget _buildTranscriptionBox({
    required String text,
    required VoidCallback onCancel,
    required double width,
  }) {
    return Container(
      width: width,
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey.shade600),
            onPressed: text.isNotEmpty ? onCancel : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback? onPress, {
    Color color = Colors.grey,
    Color backgroundColor = Colors.pinkAccent,
    bool fab = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: fab
          ? FloatingActionButton(
              onPressed: onPress,
              backgroundColor: backgroundColor,
              child: Icon(icon),
            )
          : IconButton(
              icon: Icon(icon, size: 32.0),
              color: color,
              onPressed: onPress,
            ),
    );
  }

  Widget _buildTaskWidgets({
    required Task task,
    required VoidCallback onDelete,
    required VoidCallback onComplete,
  }) {
    return TaskWidget(
      label: task.label,
      onDelete: onDelete,
      onComplete: onComplete,
    );
  }

  void _showStatus(String action) {
    final label =
        "Task $action : ${incompleteTasks.length} left / $numArchived archived";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
  }
}
