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
    final screenWidth = 0.9 * MediaQuery.of(context).size.width;
    final screenHeight = 0.7 * MediaQuery.of(context).size.height;

    var image;
    if (widget.isFrontImage)
      image = FileImage(File(imageHandler.frontImagePath!));
    else
      image = FileImage(File(imageHandler.sideImagePath!));

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth,
          maxHeight: screenHeight,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: image),
            CustomPaint(
              size: Size(screenWidth, screenHeight),
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
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(10, 10);
    final p2 = Offset(size.width - 20, size.height - 20);

    final p3 = Offset(50, 50);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;

    canvas.drawLine(p1, p2, paint);

    canvas.drawCircle(p1, 10, paint);
    canvas.drawCircle(p2, 10, paint);
    canvas.drawCircle(p3, 10, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
