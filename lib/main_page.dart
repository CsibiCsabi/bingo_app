import 'package:bingo_app/models/tile.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List tasks = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
  List<List> rows = [];

  void getTaskRows() {
    setState(() {
      rows = [];
      tasks.shuffle();
      for (int i = 0; i < 3; i++) {
        // Row sor = Row()
        List sor = [];
        for (int k = 0; k < 4; k++) {
          sor.add(tasks[i * 4 + k]);
        }
        rows.add(sor);
      }
    });
  }

  List taskList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void finishTask(task) {
    taskList[tasks.indexOf(task)] = true;
    for (bool i in taskList) {
      if (!i) {
        print("Not all tasks are finished!");
        return;
      }
    }
    print("all tasks finsihed!!!!!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: getTaskRows, child: const Text("data")),
          ...rows.map((datas) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: datas.map((item) => Tile(item, finishTask)).toList());
          })
        ],
      ),
    );
  }
}
