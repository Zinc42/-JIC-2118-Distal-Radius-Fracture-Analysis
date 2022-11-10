import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';
import 'results_edit_screen.dart';
import "screen_button.dart";

import 'dart:io';

class ImageResultsScreen extends StatefulWidget {
  final bool isFrontImage;

  const ImageResultsScreen({super.key, required this.isFrontImage});

  static const String id = "image_results_screen";

  @override
  State<ImageResultsScreen> createState() => _ImageResultsScreen();
}

class _ImageResultsScreen extends State<ImageResultsScreen> {
  ImageHandler imageHandler = ImageHandler();

  void toEditImage() {
    print("Edit Image");
    // Update the current image to analyse in Image Handler
    imageHandler.isFrontImage = widget.isFrontImage;
    Navigator.of(context).pushNamed(ResultsEditScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String? imagePath = widget.isFrontImage
        ? imageHandler.frontImagePath
        : imageHandler.sideImagePath;

    return Scaffold(
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 35.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ResultsWidgets.getHeader(widget.isFrontImage),
                  ResultsWidgets.getImageInfo(
                      screenWidth, screenHeight, imagePath),
                  ResultsWidgets.getBottomButtons(toEditImage)
                ])));
  }
}

// Created this class to be able to use the widgets in the screenshot handler
class ResultsWidgets {
  static Widget getHeader(isFrontImage) {
    String title;
    if (isFrontImage)
      title = "Main Image";
    else
      title = "Side Image";

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(left: 10, child: BackButton()),
        Align(
            child: Text(
          title,
          textAlign: TextAlign.center,
          textScaleFactor: 1.5,
        )),
      ],
    );
  }

  static Widget getImageInfo(width, height, imagePath) {
    final displayWidth = width - 80;
    final displayHeight = displayWidth / 9 * 16;

    var image = FileImage(File(imagePath));

    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: displayWidth,
          maxWidth: displayWidth,
          minHeight: displayHeight,
          maxHeight: displayHeight,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: image),
            CustomPaint(
              size: Size(displayWidth, displayHeight),
              painter: ResultsPainter(),
            )
          ],
        ));
  }

  static Widget getBottomButtons(toEditImage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScreenButton(
          buttonText: "Edit Points",
          pressFunction: toEditImage,
          width: 200,
        ),
      ],
    );
  }
}

// Handles painting the circles and lines of the measurements
class ResultsPainter extends CustomPainter {
  ImageHandler imageHandler = ImageHandler();

  @override
  void paint(Canvas canvas, Size size) {
    final p1;
    final p2;
    final p1l;
    final p1r;
    final p2l; // reference point used to draw horizontal line
    final p2r;
    if (imageHandler.isFrontImage) {
      p1 = Offset(imageHandler.getRadialStyloidFrontX(), imageHandler.getRadialStyloidFrontY());
      p2 = Offset(imageHandler.getMinArticularSurfaceX(), imageHandler.getMinArticularSurfaceY());

      p1l = Offset(0, imageHandler.getRadialStyloidFrontY());
      p1r = Offset(size.width, imageHandler.getRadialStyloidFrontY());
      p2l = Offset(0, imageHandler.getMinArticularSurfaceY());
      p2r = Offset(size.width, imageHandler.getMinArticularSurfaceY());
    } else {
      p1 = Offset(imageHandler.getLateralUpperX(), imageHandler.getLateralUpperY());
      p2 = Offset(imageHandler.getLateralLowerX(), imageHandler.getLateralLowerY());

      p1l = Offset(0, imageHandler.getLateralUpperY());
      p1r = Offset(size.width, imageHandler.getLateralUpperY());
      p2l = Offset(0, imageHandler.getLateralLowerY());
      p2r = Offset(size.width, imageHandler.getLateralLowerY());
    }

    final paintRed = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final paintBlack = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    canvas.drawLine(p1, p2, paintRed);
    canvas.drawLine(p1l, p1r, paintRed);
    canvas.drawLine(p2l, p2r, paintRed);

    canvas.drawCircle(p1, 8, paintBlack);
    canvas.drawCircle(p2, 8, paintBlack);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
