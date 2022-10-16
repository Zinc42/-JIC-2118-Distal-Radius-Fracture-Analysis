import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';
import "screen_button.dart";

class ResultsEditScreen extends StatefulWidget {
  const ResultsEditScreen({super.key});

  static const String id = "results_edit_screen";

  @override
  State<ResultsEditScreen> createState() => _ResultsEditScreenState();
}

class _ResultsEditScreenState extends State<ResultsEditScreen> {
  ImageHandler imageHandler = ImageHandler();


  double getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  void cancelEdit() {
    // cancel edit and return to results screen
    print("Cancel Edit");
    Navigator.of(context).pop();
  }

    void confirmEdit() {
    // save edited measurement poiunts and return to results screen
    print("Confirm Edit");
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
      height: state.getScreenHeight() - 220,
      width: state.getScreenWidth() - 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: const Text("Insert Drag and Drop Edit Area")
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