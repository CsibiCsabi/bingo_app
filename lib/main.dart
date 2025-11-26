import 'package:bingo_app/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 28, 8, 160),
  );

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        
      ),
      home: Scaffold(
        
        body: MainPage()
      )
    );
  }
}
