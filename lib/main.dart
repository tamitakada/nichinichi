import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.white30)
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.white)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: TextStyle(fontFamily: "Zen", color: Colors.white30, letterSpacing: 2)
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: "TimeMachine", color: Colors.white, letterSpacing: 10, fontSize: 20, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: "TimeMachine", color: Colors.white, letterSpacing: 6, fontSize: 16),
          headlineSmall: TextStyle(fontFamily: "Zen", fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2, fontSize: 15),
          bodyMedium: TextStyle(fontFamily: "Zen", color: Colors.white, fontSize: 14),
          bodySmall: TextStyle(fontFamily: "Zen", color: Colors.white, fontSize: 12)
        )
      ),
      home: const HomePage(),
    );
  }
}
