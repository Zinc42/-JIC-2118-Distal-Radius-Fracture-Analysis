import 'package:distal_radius/image_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'dart:async';
import 'dart:io';
//import "camera_helper.dart";

class CameraScreen extends StatefulWidget {
  CameraScreen({required this.cameras, super.key});

  late List<CameraDescription> cameras;

  static const String id = "camera_screen";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  // set up camera controller cameras
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 35, 0, 20),
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: const [
              Positioned(left: 10, child: BackButton()),
              Align(
                  child: Text(
                "From Camera",
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              )),
            ]),
            const SizedBox(height: 20),
            getCameraPreview(screenWidth, screenHeight),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(50, 50),
                shape:
                  const CircleBorder(side: BorderSide(color: Colors.black)),
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.grey.shade300,
              ),
              onPressed: () {
                print("Shutter");
                takeImage();
              },
              child: Container(
                  decoration: BoxDecoration(
                color: Colors.grey.shade500,
                shape: BoxShape.circle,
              )),
            ),
          ],
        ),
      ),
    );
  }

  // generates the CameraPreview widget to place in the screen
  Widget getCameraPreview(var screenWidth, var screenHeight) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        height: screenHeight - 160,
        width: screenWidth - 60,
        child: CameraPreview(controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Center on Line",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(height: 30),
                Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        minHeight: screenHeight - 350,
                        maxHeight: screenHeight - 350),
                    child: const VerticalDivider(
                      color: Colors.red,
                      width: 5,
                      thickness: 5,
                      indent: 0,
                      endIndent: 0,
                    )),
              ],
            )),
      ),
    );
  }

  // takes a picture from camera and displays it on a temporary placeholder screen
  void takeImage() async {
    try {
      if (controller.value.isInitialized) {
        final image = await controller.takePicture();

        if (!mounted) {
          return;
        }

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageEditScreen(imagePath: image.path)));
      }
    } catch (e) {
      print(e);
    }
  }
}

// temporary screen to display any images taken.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Taken')),
      body: Image.file(File(imagePath)),
    );
  }
}
