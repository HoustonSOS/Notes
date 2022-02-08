import 'package:flutter/material.dart';
import 'package:localization/screens/notes.dart';

import 'model/note.dart';
void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      home: NotesPage(),
    );
  }
}


