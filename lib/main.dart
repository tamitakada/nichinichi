import 'dart:io';

import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Nichinichi');
    setWindowMinSize(const Size(920, 200));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nichinichi",
      theme: ThemeData(
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          isDense: true,
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.white30)
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Colors.white)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: const TextStyle(fontFamily: "Zen", color: Colors.white30, letterSpacing: 2)
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: "TimeMachine", color: Colors.white, letterSpacing: 10, fontSize: 20, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: "TimeMachine", color: Colors.white, letterSpacing: 6, fontSize: 16),
          headlineSmall: TextStyle(fontFamily: "Zen", fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2, fontSize: 16),
          bodyMedium: TextStyle(fontFamily: "Zen", color: Colors.white, fontSize: 16),
          bodySmall: TextStyle(fontFamily: "Zen", color: Colors.white, fontSize: 14)
        )
      ),
      home: const HomePage(),
    );
  }
}
