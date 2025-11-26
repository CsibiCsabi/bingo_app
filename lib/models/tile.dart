import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  Tile(this.task, this.onFinish, {super.key});

  String task;

  Function onFinish;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  void makeImage() {
    print("making image...");
    widget.onFinish(widget.task);
    switchImage();
  }

  bool imageTaken = false;

  void switchImage(){
    setState(() {
      imageTaken = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double oszto = 4.7;
    return FittedBox(
        fit: BoxFit.cover,
        child: Container(
          width: screenWidth / oszto,
          height: screenWidth / oszto,
          decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.primary,
            //borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: imageTaken ? Image(
            image: NetworkImage("https://media.istockphoto.com/id/1091697372/es/foto/aeropuerto-selfie.jpg?s=1024x1024&w=is&k=20&c=pZVEBEceHUDcNOr7O0ztD6ukPPmY5ssXyyxgSWMgXaI="),
            fit: BoxFit.cover,
            ) :
          //not taken the img
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
Text(widget.task, style: TextStyle(
                    fontSize: screenWidth / (oszto*9)
                  ), softWrap: true,),
                Container(
                  height: 30,
                    child: ElevatedButton(
                  onPressed: makeImage,
                  child: Icon(Icons.camera_alt_outlined)
                ))
              ],
            ),
          ),
        ),
    );
  }
}
