import 'package:bingo_app/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((fn){runApp(const MainApp());});

  
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
        home: MainPage());
  }
}
