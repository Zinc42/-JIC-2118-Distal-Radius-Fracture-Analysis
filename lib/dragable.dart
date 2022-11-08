import 'package:flutter/material.dart';


//This class creates a dragable point object on a screen
class Drag_Button extends StatefulWidget {
  const Drag_Button(
      {super.key,
      required this.startDragFunction,
      required this.pressFunction,
      required this.endDragFunction,
      required this.topPos,
      required this.leftPos,
      required this.color});

  //Call back function that gets called on tick whenever the user is dragging the draggable
  final Function(DragStartDetails) startDragFunction;
  final Function(DragUpdateDetails) pressFunction;
  final Function(DragEndDetails) endDragFunction;

  //Determines the y position of the draggable on screen
  final double topPos;

  //Determines the x position of the draggable on screen
  final double leftPos;

  final Color color;

  double getTop() {
    return topPos;
  }

  double getLeft() {
    return leftPos;
  }




  @override
  State<Drag_Button> createState() => _Drag_ButtonState();
}

class _Drag_ButtonState extends State<Drag_Button> {

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: widget.topPos,
      left: widget.leftPos,
      child: GestureDetector(
        //OnPanUpdate gesture allows us to click and drag stuff
        onPanStart: widget.startDragFunction,
        onPanUpdate: widget.pressFunction,
        onPanEnd: widget.endDragFunction,
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget.color, border: Border.all(color: Colors.black)),
          width: 20,
          height: 20,
          //color: widget.color,
        ),
      ),
    );
  }
}
