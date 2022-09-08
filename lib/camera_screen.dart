import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
        margin: const EdgeInsets.symmetric(vertical: 35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getCameraPreview(),
            const SizedBox(height: 30),
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
                },  
                child: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCameraPreview() {
    return CameraPreview(controller, 
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
            constraints: const BoxConstraints(minHeight: 100, maxHeight: 100),
            child: const VerticalDivider(
              color: Colors.red,
              width: 5, 
              thickness: 5,
              indent: 0,
              endIndent: 0,
            )
          ),
          const SizedBox(height: 30),
        ],
      )
    );
  }
}