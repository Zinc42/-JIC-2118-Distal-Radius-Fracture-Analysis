import 'package:flutter/material.dart';

class ScreenButton extends StatelessWidget {
  const ScreenButton({required this.buttonText, required this.pressFunction, this.height = 50.0, this.width = 300.0});

  final String buttonText;
  final VoidCallback pressFunction;

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: pressFunction,
        child: Text(buttonText),
      ),
    );
  }
}
