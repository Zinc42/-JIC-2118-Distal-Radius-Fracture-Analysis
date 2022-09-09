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
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0], 
      ResolutionPreset.max,
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
        margin: const EdgeInsets.symmetric(vertical: 35),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center, 
              children: const [
                Positioned(left: 10, child: BackButton()),
                Align(
                  child: Text(
                    "From Camera",
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  )
                ),
              ]
            ),
            const SizedBox(height: 20),
            getCameraPreview(screenWidth, screenHeight),
            const SizedBox(height: 10),
            SizedBox(
              height: 50.0,
              width: 50.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const CircleBorder(
                      side: BorderSide(color: Colors.black),
                    )),
                  backgroundColor: MaterialStateProperty.all(const Color(0x00a3a3a3)),
                ),
                onPressed: () {
                  print("Shutter");
                  takeImage();
                },  
                child: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCameraPreview(var screenWidth, var screenHeight) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
        height: screenHeight - 175,
        width: screenWidth - 60,
        child: CameraPreview(controller, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Text(
                "Center on Line", 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: screenHeight - 350, maxHeight: screenHeight - 350),
                child: const VerticalDivider(
                  color: Colors.red,
                  width: 5, 
                  thickness: 5,
                  indent: 0,
                  endIndent: 0,
                )
              ),
            ],
          )
        ),
      ),
    );
  }

  void takeImage() async {
    try {
      final image = await controller.takePicture();

      if (!mounted) {
        return;
      }

      await Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: image.path))
      );
    } catch (e) {
      print(e);
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}