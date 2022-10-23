import 'package:distal_radius/image_handler.dart';
import 'package:flutter/material.dart';
import 'results_edit_screen.dart';

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

  Widget getHeader() {
    String title;
    if (widget.isFrontImage)
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

  Widget getImageInfo() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final displayWidth = screenWidth - 40;
    final displayHeight = screenHeight - 220;

    var image;
    if (widget.isFrontImage)
      image = FileImage(File(imageHandler.frontImagePath!));
    else
      image = FileImage(File(imageHandler.sideImagePath!));

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

  Widget getBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('Edit Image'),
          onPressed: toEditImage,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [getHeader(), getImageInfo(), getBottomButtons()])));
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
      p1 = Offset(imageHandler.getRadialStyloidX(), imageHandler.getRadialStyloidY());
      p2 = Offset(imageHandler.getMinArticularSurfaceX(), imageHandler.getMinArticularSurfaceY());


      p1l = Offset(0, imageHandler.getRadialStyloidY());
      p1r = Offset(size.width, imageHandler.getRadialStyloidY());
      p2l = Offset(0, imageHandler.getMinArticularSurfaceY());
      p2r = Offset(size.width, imageHandler.getMinArticularSurfaceY());
    } else {
      // Side Image not yet Implemented
      // random default values used
      p1 = Offset(0, 0);
      p2 = Offset(size.width - 20, size.height - 20);
      p1l = Offset(0, 0);
      p1r = Offset(size.width, 0);
      p2l = Offset(0, size.height - 2);
      p2r = Offset(size.width, size.height - 2);
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
