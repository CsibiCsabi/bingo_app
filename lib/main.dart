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
            appBar: AppBar(
              elevation: 3,
              shadowColor: Colors.black,
              bottom: PreferredSize(preferredSize: const Size.fromHeight(3), child: Container(color: Colors.black, height: 3,)),
              title: const Row(
                children: [
                  Icon(Icons.abc),
                  SizedBox(width: 90),
                  Text(
                    'HUMAN BINGO',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            body: const MainPage()));
  }
}
