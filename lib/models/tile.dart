import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;

class Tile extends StatefulWidget {
  Tile(this.task, this.onFinish, {super.key});

  String task;
  Function onFinish;

  void setCorner(String corn) {
    corner = corn;
  }

  String corner = "none";

  bool imageTaken = false;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  void makeImage() {
    if (kIsWeb) {
      webCamera();
    } else {
      pickImage(ImageSource.camera);
    }
  }

  File? image;

  final picker = ImagePicker();

  Uint8List? webImage;

  Future<void> pickImage(ImageSource source) async {
    final PickedFile = await picker.pickImage(source: source);

    if (kIsWeb) {
      webImage = await PickedFile!.readAsBytes();
    }
    if (PickedFile != null) {
      setState(() {
        image = File(PickedFile.path);
        widget.imageTaken = true;
        widget.onFinish(widget.task);
      });
    }
  }

  CameraController? webController;

  Future<void> webCamera() async {
    _cameras = await availableCameras();
    webController = CameraController(_cameras[0], ResolutionPreset.max);

    

    try {
      await webController!.initialize();
      if (!mounted) return;

      // Show live preview in a dialog
      await showDialog(
          context: context,
          builder: (context) => Animate(
                // effects: [FadeEffect(), ScaleEffect()],
                child: AlertDialog(
                  backgroundColor: Colors.black.withValues(alpha: 0.95),
                  contentPadding: const EdgeInsets.fromLTRB(
                      16, 16, 16, 16), // left, top, right, bottom
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(24),
                    side: const BorderSide(color: Colors.white, width: 3),
                  ),
                  content: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: webController!.value.aspectRatio,
                        child: CameraPreview(webController!),
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3)),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () async {
                            // Capture image
                            final picture = await webController!.takePicture();
                            webImage = await picture.readAsBytes();

                            setState(() {
                              widget.imageTaken = true;
                            });

                           await Future.delayed(200.ms);

                            Navigator.pop(context); // Close dialog
                          },
                          child: Ink(
                          height: 60, // button height
                          width: 60,  // button width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14), // button corners
                            color: const Color.fromRGBO(255, 255, 255, 0.2), // semi-transparent background
                            border: Border.all(color: Colors.white, width: 2), // white border
                          ), // End BoxDecoration
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30,
                            ), // End Icon
                          ), // End inner Center
                          ),
                        ),
                      ),
                    ),
                    )
                  ],
                ),
              )
                  .animate()
                  .slideY(
                      begin: -1,
                      end: 0,
                      curve: Curves.easeOut,
                      duration: 500.ms)
                  .fadeIn(duration: 500.ms));
    } catch (e) {
      print("Camera error: $e");
    } finally {
      await webController?.dispose();
      webController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double oszto = 4.7;
    double size = screenWidth / oszto;
    double round = 12;
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.only(
          topLeft: widget.corner == "topLeft"
              ? Radius.circular(round)
              : Radius.circular(0),
          topRight: widget.corner == "topRight"
              ? Radius.circular(round)
              : Radius.circular(0),
          bottomLeft: widget.corner == "bottomLeft"
              ? Radius.circular(round)
              : Radius.circular(0),
          bottomRight: widget.corner == "bottomRight"
              ? Radius.circular(round)
              : Radius.circular(0)),
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.primary,
              //borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
          child: widget.imageTaken
              ? FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      onPressed: makeImage,
                      child: kIsWeb
                          ? Image.memory(webImage!)
                          : Image.file(image!)))
              :
              //not taken the img
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        overlayColor: Colors.transparent),
                    onPressed: makeImage,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.task,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth / (oszto * 8),
                            color: Colors.black,
                          ),
                          softWrap: true,
                        ),
                        Container(
                            height: size / 3,
                            width: size / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: size / 5,
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              weight: 1,
                            )),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
