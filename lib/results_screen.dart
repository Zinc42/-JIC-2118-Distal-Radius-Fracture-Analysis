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

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image(height: 300, width: 200, image: frontImage),
      Image(
        height: 300,
        width: 200,
        image: sideImage,
      ),
    ]);
  }

  Widget getResultsInfo() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: Column(children: [
          getResultValue("Volar Tilt", 1.0, 0.5, 1.5),
          SizedBox(height: 20),
          getResultValue("Radial Height", 0.3, 0.5, 1.5),
          SizedBox(height: 20),
          getResultValue("Radial Inclination", 0.0, 2.0, 3.5)
        ]));
  }

  Column getResultValue(String title, double value, double min, double max) {
    Color color;

    double difference = (value - min).abs();
    if (value <= max && value >= min)
      color = Colors.green;
    else if (difference < 1.0)
      color = Colors.yellow;
    else
      color = Colors.red;

    String rangeText = '$min - $max';

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title, textAlign: TextAlign.left),
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              children: [
                Text(value.toString(), style: TextStyle(color: color)),
                Spacer(),
                Text(rangeText, style: TextStyle(color: Colors.green))
              ],
            ))
      ],
    );
  }

  TextEditingController textController(text) {
    return TextEditingController(text: text);
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
