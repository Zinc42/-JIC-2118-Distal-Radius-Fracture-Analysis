import 'package:flutter/material.dart';
import 'dart:io';
import "dragable.dart";
import 'dart:math';

class DragScreen extends StatefulWidget {
  final String passedImagePath;

  const DragScreen({super.key, required this.passedImagePath});

  //const DragScreen({Key? key}) : super(key: key);
  static const String id = "drag_screen";

  @override
  State<DragScreen> createState() => _DragScreenState();
}

class _DragScreenState extends State<DragScreen> {
  late Drag_Button button;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    button = Drag_Button(pressFunction: DragableUpdateCallback);
    print("INITIALIZED");
  }

  @override
  Widget build(BuildContext context) => _DragScreenView(state: this);

  String getImage() {
    return widget.passedImagePath;
  }
//TODO: make copy of a dragable callback to apply to other button
  void DragableUpdateCallback(details) {
    if (button != null) {
      var screenWidth = MediaQuery.of(context).size.width;
      var screenHeight = MediaQuery.of(context).size.height;
      double newTop =
          min(screenHeight - 225, max(0, button.getTop() + details.delta.dy));
      double newLeft =
          min(screenWidth - 70, max(0, button.getLeft() + details.delta.dx));
      button = Drag_Button(
          pressFunction: DragableUpdateCallback,
          topPos: newTop,
          leftPos: newLeft);
    }
    setState(() {});
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
          height: screenHeight - 150,
          child: Stack(
            children: [
              Image.file(
                File(state.getImage()),
              ),
              state.button
            ],
          ),
        ),
      ),
    ));
  }
}
