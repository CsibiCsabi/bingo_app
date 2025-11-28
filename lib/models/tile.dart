import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class Tile extends StatefulWidget {
  Tile(this.task, this.onFinish, {super.key});

  String task;

  Function onFinish;

  bool imageTaken = false;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  void makeImage() {
    print("making image...");
    pickImage(ImageSource.camera);
    widget.onFinish(widget.task);
  }

  




  File? image;

  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {

    final PickedFile = await picker.pickImage(source: source);

    if (PickedFile != null) {
      setState(() {
        image = File(PickedFile.path);
        widget.imageTaken = true;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double oszto = 4.7;
    return FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: screenWidth / oszto,
          height: screenWidth / oszto,
          decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.primary,
            //borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: widget.imageTaken ?
              FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: Image.file(image!)
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
                  height: 40,
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
