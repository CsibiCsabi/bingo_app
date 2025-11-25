import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  Tile(this.task, this.onFinish, {super.key});

  String task;

  Function onFinish;

  @override
  State<Tile> createState() => _TileState();

}

class _TileState extends State<Tile> {

  void makeImage(){
    print("making image...");
    widget.onFinish(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double oszto = 4.7;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
          width: screenWidth / oszto,
          height: screenWidth / oszto,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.task),
                ElevatedButton(onPressed: makeImage, child: Text("Finish"))
              ],
            ),
          ),
        ),
    );
  }
}
