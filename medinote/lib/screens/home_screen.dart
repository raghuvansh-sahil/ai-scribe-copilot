import 'package:flutter/material.dart';
import 'package:medinote/data/languages.dart';
import 'package:medinote/widgets/transcriptor_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Language selectedLang = languages.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sytôdy'),
          backgroundColor: Colors.blueGrey,
          actions: [
            PopupMenuButton<Language>(
              onSelected: _selectLangHandler,
              itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
            ),
          ],
        ),
        body: TranscriptorWidget(lang: selectedLang),
      ),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map(
        (l) => CheckedPopupMenuItem<Language>(
          value: l,
          checked: selectedLang == l,
          child: Text(l.name),
        ),
      )
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }
}
