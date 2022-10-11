import 'package:flutter/material.dart';
import 'dart:io';
import "dragable.dart";

class DragScreen extends StatefulWidget {
  final String passedImagePath;

  const DragScreen({super.key, required this.passedImagePath});

  //const DragScreen({Key? key}) : super(key: key);
  static const String id = "drag_screen";

  @override
  State<DragScreen> createState() => _DragScreenState();
}

class _DragScreenState extends State<DragScreen> {
  @override
  Widget build(BuildContext context) => _DragScreenView(state: this);

  String getImage() {
    return widget.passedImagePath;
  }

  DragableUpdateCallback(details) {
    print(details);
    setState(() {
    });
  }
}

class _DragScreenView extends StatelessWidget {
  const _DragScreenView({super.key, required this.state});

  final _DragScreenState state;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return (Scaffold(
      appBar: AppBar(title: const Text('Image Taken')),
      body: Center(
        child: Container(
          width: screenWidth - 40,
          height: screenHeight - 250,
          child: Stack(
            children: [
              Image.file(
                File(state.getImage()),
              ),
              Drag_Button(pressFunction: state.DragableUpdateCallback),
            ],
          ),
        ),
      ),
    ));
  }
}
