import 'package:distal_radius/image_handler.dart';
import 'package:distal_radius/screenshot_handler.dart';
import 'package:flutter/material.dart';
import 'image_results_screen.dart';
import 'export_screen.dart';

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
  ScreenshotHandler screenshotHandler = ScreenshotHandler();

  void cancelResults() {
    Navigator.of(context).popUntil(ModalRoute.withName("welcome_screen"));
  }

  void toExport() async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    await screenshotHandler.saveBothImages(screenHeight, screenWidth);
    await screenshotHandler.saveTextResults(getResultsInfo());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ExportScreen()));
  }

  void toImageResults(isFront) {
    imageHandler.isFrontImage = isFront;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageResultsScreen(
                  isFrontImage: isFront,
                )));
  }

  Widget getHeader() {
    return Stack(
      alignment: Alignment.center,
      children: const [
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
    final imageWidth = 0.4 * MediaQuery.of(context).size.width;
    var frontImage = FileImage(File(imageHandler.frontImagePath!));
    var sideImage = FileImage(File(imageHandler.sideImagePath!));

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        GestureDetector(
            onTap: () => toImageResults(true),
            child: Image(height: 300, width: imageWidth, image: frontImage)),
        GestureDetector(
            onTap: () => toImageResults(false),
            child: Image(height: 300, width: imageWidth, image: sideImage))
      ]),
      SizedBox(height: 20),
      Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0)),
          child: const Text('Press Image for More Info'))
    ]);
  }

  Widget getResultsInfo() {
    double volarTilt = 1.0;
    double radialHeight = imageHandler.getRadialHeight();
    double radialInclination = imageHandler.getRadialInclination();

    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: Column(children: [
          getResultValue("Volar Tilt", volarTilt, 0.5, 1.5),
          SizedBox(height: 20),
          getResultValue("Radial Height", radialHeight, 0.5, 1.5),
          SizedBox(height: 20),
          getResultValue("Radial Inclination", radialInclination, 2.0, 3.5)
        ]));
  }

  Column getResultValue(String title, double value, double min, double max) {
    // parses a double as a string rounded to 1 decimal place
    String valueString = value.toStringAsFixed(1);

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
                Text(valueString, style: TextStyle(color: color)),
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
