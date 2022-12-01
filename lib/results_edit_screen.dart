import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';
import "screen_button.dart";
import "drag_screen.dart";

class ResultsEditScreen extends StatefulWidget {

  const ResultsEditScreen({super.key});

  static const String id = "results_edit_screen";

  @override
  State<ResultsEditScreen> createState() => _ResultsEditScreenState();
}

class _ResultsEditScreenState extends State<ResultsEditScreen> {
  ImageHandler imageHandler = ImageHandler();

  // store temp values of the key points while they are edited in the drag screen.
  late double tempFirstPointX;
  late double tempFirstPointY;
  late double tempSecondPointX;
  late double tempSecondPointY;

  void setTempPoints(double firstX, double firstY, double secondX, double secondY) {
    tempFirstPointX = firstX;
    tempFirstPointY = firstY;
    tempSecondPointX = secondX;
    tempSecondPointY = secondY;
  }

  // update the image handler with the currently stored and modified temp points
  void updatePoints() {
    if (imageHandler.isFrontImage) {
      // print("Updated Radial Styloid: $tempFirstPointX $tempFirstPointY");
      // print("Updated Min Articular Surface: $tempSecondPointX $tempSecondPointY");
      imageHandler.setRadialStyloidFront(tempFirstPointX, tempFirstPointY);
      imageHandler.setMinArticularSurface(tempSecondPointX, tempSecondPointY);
    } else {
      // print("Updated Lateral Upper: $tempFirstPointX $tempFirstPointY");
      // print("Updated Lateral Lower: $tempSecondPointX $tempSecondPointY");
      imageHandler.setlateralUpper(tempFirstPointX, tempFirstPointY);
      imageHandler.setlateralLower(tempSecondPointX, tempSecondPointY);
    }
  }

  // whether or not the current image for analysis is Front/Side is updated in the Image Handler
  // you can get the image path via imageHandler.getCurrImagepath()

  // the returned path can technically be a null string, but it shoudln't be actually possible
  // since the paths are initialized in earlier screens in the app

  double getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  void cancelEdit() {
    // cancel edit and return to results screen
    // print("Cancel Edit");
    Navigator.of(context).pop();
  }

  void confirmEdit() {
    // update points in Image Handler and return to results screen
    // print("Confirm Edit");
    updatePoints();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => _ResultsEditScreenView(state: this);
}

class _ResultsEditScreenView extends StatelessWidget {
  const _ResultsEditScreenView({super.key, required this.state});

  final _ResultsEditScreenState state;

  Widget getHeader() {
    return const Align(
      child: Text(
      "Adjust Measurements",
      textAlign: TextAlign.center,
      textScaleFactor: 1.5,
    ));
  }

  Widget getEditArea() {
    // Inset drag and drop widget here, probably easier to implement as separate widget file
    // and just port into the screen
    // @Darien

    // can get Images from the Image Handler

    return Container(
      height: (state.getScreenWidth() - 80) / 9 * 16,
      width: state.getScreenWidth() - 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: DragScreen(passedImagePath: state.imageHandler.getCurrImagepath()!, updateFunction: state.setTempPoints)
    );
  }

  Widget getBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScreenButton(
          width: state.getScreenWidth()/2 - 40,
          buttonText: "Cancel",
          pressFunction: state.cancelEdit,
        ),
        ScreenButton(
          width: state.getScreenWidth()/2 - 40,
          buttonText: "Confirm Edit", 
          pressFunction: state.confirmEdit
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      margin: const EdgeInsets.symmetric(vertical: 35.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getHeader(),
            getEditArea(),
            getBottomButtons(),
          ],
        )
      ),
    );
  }
}