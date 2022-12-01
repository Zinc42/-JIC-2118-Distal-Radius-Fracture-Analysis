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

  //This tracks whether screenshot handler is building the export results
  bool isScreenshotHandlerBuilding = false;

  void cancelResults() {
    imageHandler.reset();
    Navigator.of(context).popUntil(ModalRoute.withName("welcome_screen"));
  }

  void toExport() async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //This function changes the value of isScreenshotHandlerLoading to the passed value
    //Then sets state depending on the value. true = display loading wheel. false = display the normal results screen
    screenShotHandlerLoading(true);

    await screenshotHandler.saveBothImages(screenHeight, screenWidth);
    await screenshotHandler.saveTextResults(getResultsInfo());

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ExportScreen()));

    //changes results screen back to normal
    screenShotHandlerLoading(false);
  }

  void toImageResults(isFront) {
    imageHandler.isFrontImage = isFront;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageResultsScreen(
                  isFrontImage: isFront,
                ))).then((value) => setState(() {}));
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(height: 300, width: imageWidth, image: frontImage),
              Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                      minHeight: 200,
                      maxHeight: 200),
                  child: const VerticalDivider(
                    color: Colors.red,
                    width: 3,
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
              )),
            ]
          ),
        ),
        GestureDetector(
          onTap: () => toImageResults(false),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(height: 300, width: imageWidth, image: sideImage),
              Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                      minHeight: 200,
                      maxHeight: 200),
                  child: const VerticalDivider(
                    color: Colors.red,
                    width: 3,
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
              )),
            ]
          ),
        ),
      ]),
      const SizedBox(height: 20),
      Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0)),
          child: const Text('Press Image for More Info'))
    ]);
  }

  Widget getResultsInfo() {
    double volarTilt = imageHandler.getVolarTilt();
    double radialHeight = imageHandler.getRadialHeight();
    double radialInclination = imageHandler.getRadialInclination();

    print(volarTilt);
    print(radialHeight);
    print(radialInclination);

    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: Column(children: [
          getResultValue("Volar Tilt", volarTilt, 10, 20), //degrees
          const SizedBox(height: 20),
          getResultValue("Radial Height", radialHeight, 8, 14), //millimeters
          const SizedBox(height: 20),
          getResultValue("Radial Inclination", radialInclination, 15, 25) //degrees
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
    String units = getUnits(title);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title,
            textAlign: TextAlign.left, style: TextStyle(color: Colors.black)),
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              children: [
                Text(("$valueString $units"), style: TextStyle(color: color)),
                Spacer(),
                Text(("$rangeText $units"), style: TextStyle(color: Colors.green))
              ],
            ))
      ],
    );
  }
  //Gets the units of measurement to be displayed next to results values
  String getUnits(String title) {
    if (title == "Radial Height") {
      return "mm";
    } else {
      return "°";
    }
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

  screenShotHandlerLoading(bool isLoading) {
    isScreenshotHandlerBuilding = isLoading;
    setState(() {});
  }

//This returns all the widgets that are normally in the results screen
  Widget getResultsScreen() {
    return (Container(
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

  Widget getLoadingIndicator() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        //Progress indicator
        SizedBox(
          width: 175,
          height: 175,
          child: CircularProgressIndicator(
            strokeWidth: 15,
            backgroundColor: Colors.grey,
          ),
        ),
        //Space between the text and the circular progress indicator
        SizedBox(height: 50),
        //Text
        Text(
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            "Getting results ready \n for export..."),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isScreenshotHandlerBuilding
            ? getLoadingIndicator()
            : getResultsScreen());
  }
}
