import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medinote/providers/patient_provider.dart';
import 'package:medinote/providers/session_provider.dart';
import 'package:medinote/screens/patients_screen.dart';
import 'package:medinote/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const userId = "user_1";
  String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000'
      : 'http://127.0.0.1:8000';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: MaterialApp(
        title: 'MediNote',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
            primary: Colors.teal.shade700,
            onPrimary: Colors.white,
            primaryContainer: Colors.teal.shade50,
            onPrimaryContainer: Colors.teal.shade900,
            secondary: Colors.blue.shade700,
            onSecondary: Colors.white,
            secondaryContainer: Colors.blue.shade50,
            onSecondaryContainer: Colors.blue.shade900,
            background: Colors.grey.shade50,
            onBackground: Colors.grey.shade900,
            surface: Colors.white,
            onSurface: Colors.grey.shade900,
            surfaceVariant: Colors.grey.shade100,
            onSurfaceVariant: Colors.grey.shade700,
            outline: Colors.grey.shade300,
            outlineVariant: Colors.grey.shade200,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey.shade900,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            iconTheme: IconThemeData(color: Colors.grey.shade700),
          ),
          cardTheme: CardThemeData(
            elevation: 1,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            displaySmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            headlineSmall: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            titleLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade800,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade700,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
            labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.teal.shade700,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal.shade700,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.teal.shade700,
              side: BorderSide(color: Colors.teal.shade700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey.shade200,
            thickness: 1,
            space: 0,
          ),
          listTileTheme: ListTileThemeData(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
            subtitleTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            iconColor: Colors.grey.shade700,
          ),
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.teal.shade700,
            linearTrackColor: Colors.grey.shade200,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.grey.shade100,
            labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
            primary: Colors.teal.shade300,
            onPrimary: Colors.grey.shade900,
            primaryContainer: Colors.teal.shade800,
            onPrimaryContainer: Colors.teal.shade100,
            secondary: Colors.blue.shade300,
            onSecondary: Colors.grey.shade900,
            secondaryContainer: Colors.blue.shade800,
            onSecondaryContainer: Colors.blue.shade100,
            background: Colors.grey.shade900,
            onBackground: Colors.grey.shade100,
            surface: Colors.grey.shade800,
            onSurface: Colors.grey.shade100,
            surfaceVariant: Colors.grey.shade700,
            onSurfaceVariant: Colors.grey.shade300,
            outline: Colors.grey.shade600,
            outlineVariant: Colors.grey.shade700,
          ),
        ),
        themeMode: ThemeMode.light,
        home: PatientsScreen(userId: widget.userId),
      ),
    );
  }
}
