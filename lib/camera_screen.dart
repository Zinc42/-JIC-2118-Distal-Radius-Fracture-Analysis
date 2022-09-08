import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import "camera_helper.dart";

class CameraScreen extends StatefulWidget {
  late List<CameraDescription>? cameras;
  CameraScreen({this.cameras, super.key});

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
      widget.cameras![0], 
      ResolutionPreset.max
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
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Camera Here"),
            CameraPreview(controller),
          ],
        ),
      ),
    );
  }

}