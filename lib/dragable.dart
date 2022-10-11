import 'package:flutter/material.dart';

class Drag_Button extends StatefulWidget {
   const Drag_Button({super.key, required this.pressFunction, this.topPos = 0, this.leftPos = 0});
   const Drag_Button.withPos({super.key, required this.pressFunction, required this.topPos, required this.leftPos});

  final Function(DragUpdateDetails) pressFunction;
  final double topPos;
   final double leftPos;


  //final void Function(DragUpdateDetails) onUpdate;

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
      left:widget.leftPos,

      child: GestureDetector(
        onPanUpdate: widget.pressFunction,
        child: Container(
          width: screenWidth - 363,
          height: screenHeight - 800,
          color: Colors.red,
        ),
      ),
    );
  }
}

