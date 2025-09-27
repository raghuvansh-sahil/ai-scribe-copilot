import 'package:flutter/material.dart';
import 'package:medinote/screens/patients_screen.dart';
import 'package:medinote/services/api_service.dart';
import 'package:medinote/widgets/recording_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const userId = "user_123";
  const baseUrl = 'https://app.scribehealth.ai/api';
  const authToken = 'your_auth_token_here';

  ApiServiceHandler.init(baseUrl: baseUrl, authToken: authToken);
  runApp(MyApp(userId: userId));
}

class MyApp extends StatefulWidget {
  final String userId;
  const MyApp({super.key, required this.userId});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.amber,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Record - ")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: const RecordingWidget(),
        ),
      ),
    );
  }
}
