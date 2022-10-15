import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';

import "screen_button.dart";

import 'dart:io';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  static const String id = "results_screen";

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

// State class that handles logic in the screen
// contains all functions relevant to business logic
class _ResultsScreenState extends State<ResultsScreen> {
  ImageHandler imageHandler = ImageHandler();

  void cancelResults() {
    print("Cancelled");
  }

  void toExport() {
    print("Send to export");
  }

  TextEditingController textController(text) {
    return TextEditingController(text: text);
  }

  Widget getHeader() {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Positioned(left: 10, child: BackButton()),
        Align(
            child: Text(
          "Results",
          textAlign: TextAlign.center,
          textScaleFactor: 1.5,
        )),
      ],
    );
  }

  Widget getImages() {
    var frontImage = FileImage(File(imageHandler.frontImagePath!));
    var sideImage = FileImage(File(imageHandler.sideImagePath!));

    return Row(children: [
      Image(height: 200, width: 200, image: frontImage),
      Image(
        height: 200,
        width: 200,
        image: sideImage,
      ),
    ]);
  }

  Widget getResultsInfo() {
    return Column(children: [
      TextField(
          enabled: false,
          style: TextStyle(color: Colors.green),
          controller: textController("here"))
    ]);
  }

  Widget getBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('Return Home'),
          onPressed: cancelResults,
        ),
        ElevatedButton(
          child: const Text('Export'),
          onPressed: toExport,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 35.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getHeader(),
                  getImages(),
                  getResultsInfo(),
                  getBottomButtons()
                ])));
  }
}
