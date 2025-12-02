import 'package:bingo_app/models/gradient_text.dart';
import 'package:bingo_app/models/tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List tasks = [
    "Is vegetarian",
    "Is left handed",
    "Doesn’t like chocolate",
    "Prefers Pepsi over Coke",
    "Speaks 3+ languages",
    "Plays a musical instrument",
    "Has visited 5+ countries",
    "Who can cross their eyes & prove it",
    "Has green eyes",
    "Likes cats better than dogs",
    "Can jump on one leg & prove it",
    "Has a tattoo"
  ];
  List<List> rows = [];

  void randomize() {
    tasks.shuffle();
  }

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
    showBingo();
  }

  List<Tile> taskTiles = [];

  void getCells() {
    print("eleg sokszor lefut...");
    taskTiles = [];
    for (int i = 0; i < tasks.length; i++) {
      taskTiles.add(Tile(tasks[i], finishTask));
    }
  }

  void showBingo() {
    double screenWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text("BINGO!")),
        content: SizedBox(
          height: screenWidth / 4,
          width: screenWidth / 3,
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("YAY!"))
        ],
        backgroundColor: Color.fromARGB(180, 0, 0, 0),
        titleTextStyle: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.w200),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }

  List<Widget> cells = [];
  var borderWidth = 2.5;
  var borderColor = Colors.black;
  void getGrid(int size) {
    cells = [];
    double round = 14;
    for (int i = 0; i < tasks.length; i++) {
      if (i == 0) {
        taskTiles[i].setCorner("topLeft");
      } else if (i == size - 1) {
        taskTiles[i].setCorner("topRight");
      } else if (i == tasks.length - size) {
        taskTiles[i].setCorner("bottomLeft");
      } else if (i == tasks.length - 1) {
        taskTiles[i].setCorner("bottomRight");
      }
      cells.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: i == 0 ? Radius.circular(round) : Radius.circular(0),
              topRight:
                  i == size - 1 ? Radius.circular(round) : Radius.circular(0),
              bottomLeft: i == tasks.length - size
                  ? Radius.circular(round)
                  : Radius.circular(0),
              bottomRight: i == tasks.length - 1
                  ? Radius.circular(round)
                  : Radius.circular(0)),
          border: Border(
              right: BorderSide(
                  color: borderColor, width: i % size == size - 1 ? borderWidth : borderWidth / 2),
              bottom: BorderSide(
                  color: borderColor,
                  width: i > tasks.length - size - 1 ? borderWidth : borderWidth / 2),
              left:
                  BorderSide(color: borderColor, width: i % size == 0 ? borderWidth : borderWidth / 2),
              top: BorderSide(color: borderColor, width: i < size ? borderWidth : borderWidth / 2)),
        ),
        child: taskTiles[i],
      ));
    }
  }

  void restart() {
    setState(() {
      randomize();
      taskList = [
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
      for (Widget i in taskTiles) {
        (i as Tile).imageTaken = false;
      }
    });
    getCells();
  }

  @override
  void initState() {
    super.initState();
    getCells();
  }

  var boxcolor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width > 700 ? 4 : 3;
    getGrid(size);
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Color.fromRGBO(255, 109, 51, 1),
            Color.fromRGBO(77, 86, 245, 1)
          ],
              begin: AlignmentGeometry.centerLeft,
              end: AlignmentGeometry.bottomRight)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Material(
                color: Colors.transparent, // Fontos!
                child: InkWell(
                  onTap: () {
                    showBingo();
                  },
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color.fromARGB(255, 15, 63, 102),
                  highlightColor: Color.fromARGB(255, 63, 131, 199),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius:
                          BorderRadius.circular(8), // Ugyanaz a radius
                    ),
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Text('data'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Expanded(
                child: GridView.count(crossAxisCount: size, children: cells),
              ),
              Material(
                color: Colors.transparent, // Fontos!
                child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: restart,
                    splashColor: Color.fromRGBO(255, 109, 51, 0.5),
                    child: Ink(
                      height: 50,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'RESTART',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            letterSpacing: 0.7,
                            color: Colors.white
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// tasks.map((e) => Tile(e, finishTask)).toList(),
/*
...rows.map((datas) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: datas.map((item) => Tile(item, finishTask)).toList());
          })
*/
