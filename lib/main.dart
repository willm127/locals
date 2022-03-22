import 'package:flutter/material.dart';

import './views/feed_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _theme = ThemeData(
    primarySwatch: Colors.blue,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      labelMedium: TextStyle(color: Colors.white54, fontSize: 16),
      labelSmall: TextStyle(color: Colors.white54, letterSpacing: 0),
      bodyLarge: TextStyle(color: Colors.blue),
      bodyMedium: TextStyle(fontSize: 18),
    ),
    brightness: Brightness.dark,
    canvasColor: const Color.fromRGBO(22, 22, 22, 1.0),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locals',
      theme: _theme,
      home: const FeedPage(),
    );
  }
}
