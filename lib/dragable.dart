import 'package:flutter/material.dart';

class Drag_Button extends StatefulWidget {
  const Drag_Button({super.key, required this.pressFunction });

  final Function(DragUpdateDetails) pressFunction;
  //final void Function(DragUpdateDetails) onUpdate;

  @override
  State<Drag_Button> createState() => _Drag_ButtonState();
}

class _Drag_ButtonState extends State<Drag_Button> {

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onPanUpdate: widget.pressFunction,
      child: Container(
        width: screenWidth - 363,
        height: screenHeight - 800,
        color: Colors.red,
      ),
    );
  }
}

