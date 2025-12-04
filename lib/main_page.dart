import 'dart:math';

import 'package:bingo_app/models/tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isGrey = true;
  final random = Random();
  Color ccOrange = const Color.fromRGBO(255, 109, 51, 1);
  Color ccPurple = const Color.fromRGBO(77, 86, 245, 1);
  Color sarga = const Color.fromARGB(255, 255, 255, 255);
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

  var resetCount = 0;

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
        return;
      }
    }
    showBingo();
  }

  List<Tile> taskTiles = [];

  void getCells() {
    taskTiles = [];
    for (int i = 0; i < tasks.length; i++) {
      taskTiles.add(Tile(tasks[i], finishTask));
    }
  }

  void showBingo() {
    double screenWidth = MediaQuery.of(context).size.width;
    int imgNum = random.nextInt(taskTiles.length);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(14),
          child: Animate(
            effects: [
              const ScaleEffect(
                duration: Duration(milliseconds: 300),
                begin: Offset(0, 0),
              ),
              ShimmerEffect(
                color: ccPurple,
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 400),
              ),
              //ColorEffect(end: Color.fromRGBO(46, 51, 159, 1), blendMode: BlendMode.color)
            ],
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(177, 0, 0, 0),
                borderRadius: BorderRadius.circular(14),
                //border: Border.all(color: ccPurple, width: 2)
              ),
              height: MediaQuery.of(context).size.height / 2.5,
              width: screenWidth / 1.5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: "B I N G O"
                          .characters
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final i = entry.key;
                        final char = entry.value;
                        return Text(char, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
                            .animate(
                              delay: (i * 70).ms,
                              onPlay: (c) => c.repeat(reverse: true),
                            )
                            .moveY(begin: -5, end: 15, duration: 500.ms);
                      }).toList(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14)
                      ),
                      height: screenWidth / 2.5,
                      width: screenWidth / 2.5,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(14),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          clipBehavior: Clip.hardEdge,
                          child: kIsWeb ? taskTiles[imgNum].webImage != null ? Image.memory(taskTiles[imgNum].webImage!) : const Placeholder(color: Colors.transparent,)
                                            : taskTiles[imgNum].image != null ? Image.file(taskTiles[imgNum].image!) : const Placeholder(color: Colors.transparent,),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                          Material(
                            color: Colors.transparent, // Fontos!
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                              splashColor: ccPurple.withAlpha(0),
                              child: Ink(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color.fromARGB(100, 0, 0, 0),
                                  border: Border.all(color: sarga, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    'YAY!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        letterSpacing: 0.7,
                                        color: sarga),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 5,)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        titleTextStyle: const TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.w200),
        contentTextStyle: const TextStyle(
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
              topLeft:
                  i == 0 ? Radius.circular(round) : const Radius.circular(0),
              topRight: i == size - 1
                  ? Radius.circular(round)
                  : const Radius.circular(0),
              bottomLeft: i == tasks.length - size
                  ? Radius.circular(round)
                  : const Radius.circular(0),
              bottomRight: i == tasks.length - 1
                  ? Radius.circular(round)
                  : const Radius.circular(0)),
          border: Border(
              right: BorderSide(
                  color: borderColor,
                  width: i % size == size - 1 ? borderWidth : borderWidth / 2),
              bottom: BorderSide(
                  color: borderColor,
                  width: i > tasks.length - size - 1
                      ? borderWidth
                      : borderWidth / 2),
              left: BorderSide(
                  color: borderColor,
                  width: i % size == 0 ? borderWidth : borderWidth / 2),
              top: BorderSide(
                  color: borderColor,
                  width: i < size ? borderWidth : borderWidth / 2)),
        ),
        child: taskTiles[i],
      ));
    }
  }

  void restart() {
    setState(() {
      resetCount++;
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
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isGrey = false;
      });
    });
  }

  bool _resetAnimation = false;
  bool _isResetting = false;

  var boxcolor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    int size = MediaQuery.of(context).size.width > 700 ? 4 : 3;
    getGrid(size);
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: Animate(
              effects: const [
                FadeEffect(duration: Duration(milliseconds: 1000)),
                ScaleEffect(duration: Duration(milliseconds: 1000))
              ],
              child: Container(
                color: Colors.black,
                height: 3,
              ),
            )),
        centerTitle: true,
        title: Animate(
          autoPlay: true,
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 1000)),
            ScaleEffect(
                duration: Duration(milliseconds: 1000),
                begin: Offset(0, 0),
                end: Offset(1.1, 1.1)),
            ScaleEffect(
                duration: Duration(milliseconds: 150),
                begin: Offset(1.1, 1.1),
                end: Offset(1, 1),
                delay: Duration(milliseconds: 1000)),
            ShimmerEffect(
              color: Color.fromARGB(255, 167, 193, 206),
              duration: Duration(milliseconds: 2000),
              delay: Duration(milliseconds: 4000),
              size: 2,
            )
          ],
          child: const Text(
            'HUMAN BINGO',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Animate(
              autoPlay: true,
              effects: const [
                ShimmerEffect(
                  color: Color.fromARGB(255, 167, 193, 206),
                  duration: Duration(milliseconds: 2000),
                  delay: Duration(milliseconds: 2500),
                  size: 2,
                )
              ],
              child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: isGrey ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: Image.asset('assets/course_creators_gray.png'),
                ),
                AnimatedOpacity(
                  opacity: isGrey ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: Image.asset('assets/course_creators.png'),
                ),
              ],
            ),
            )),
        leadingWidth: MediaQuery.of(context).size.width / 3.5,
      ),
      body: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent, // Fontos!
                    child: InkWell(
                      onTap: () {
                        showBingo();
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: const Color.fromARGB(255, 15, 63, 102),
                      highlightColor: const Color.fromARGB(255, 63, 131, 199),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius:
                              BorderRadius.circular(8), // Ugyanaz a radius
                        ),
                        width: 80,
                        height: 80,
                        child: const Center(
                          child: Text('data'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      addAutomaticKeepAlives: true,
                      crossAxisCount: size, children: [
                      for (int i = 0; i < cells.length; i++)
                        Animate(
                          delay: (i * 120).ms,
                          effects: const [
                            SlideEffect(
                                begin: Offset(0, 0.5), end: Offset.zero),
                            FadeEffect()
                          ],
                          key: ValueKey('${resetCount}_$i'),
                          child: cells[i],
                        )
                    ]),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // RESET gomb
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          splashColor: const Color.fromRGBO(255, 109, 51, 0.5),
                          onTap: () {
                            // 1. Animáció indítása
                            setState(() {
                              _resetAnimation = true;
                              _isResetting = true;
                            });

                            // 2. Reset logika
                            restart();

                            // 3. Animáció visszaállítása
                            Future.delayed(1.seconds, () {
                              setState(() {
                                _resetAnimation = false;
                                _isResetting = false;
                              });
                            });
                          },
                          child: Ink(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color.fromRGBO(255, 255, 255, 0.2),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isResetting
                                    ? const Icon(Icons.refresh,
                                            color: Colors.white)
                                        .animate()
                                        .rotate(duration: 0.5.seconds)
                                    : const Icon(Icons.refresh,
                                        color: Colors.white),
                                const SizedBox(width: 8),
                                const Text(
                                  'RESTART',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      letterSpacing: 0.7,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Animáció amit a gomb indít
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Started new game!',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                          .animate(
                            autoPlay: false,
                            target: _resetAnimation ? 1 : 0,
                          )
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: -0.5)
                          .then(delay: 500.ms)
                          .fadeOut(duration: 300.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}