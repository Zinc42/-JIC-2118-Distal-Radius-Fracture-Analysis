import 'package:flutter/material.dart';

class ScreenButton extends StatelessWidget {
  const ScreenButton({required this.buttonText, required this.pressFunction});

  final String buttonText;
  final VoidCallback pressFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 300.0,
      child: ElevatedButton(
        onPressed: pressFunction,
        child: Text("$buttonText"),
      ),
    );
  }
}
