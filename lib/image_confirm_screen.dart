import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:crop/crop.dart';

class ImageConfirmScreen extends StatefulWidget {
  final RawImage image;

  const ImageConfirmScreen({super.key, required this.image});

  @override
  State<ImageConfirmScreen> createState() => _ImageConfirmScreen();
}

class _ImageConfirmScreen extends State<ImageConfirmScreen> {
  void initState() {
    super.initState();
  }

  void cancelImage() {
    Navigator.of(context).popUntil(ModalRoute.withName("image_upload_screen"));
  }

  void confirmImage() {
    print("Image ready to send back");
    print("Needed to change something");
  }

  Widget getBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('Cancel Upload'),
          onPressed: cancelImage,
        ),
        ElevatedButton(
          child: const Text('Confirm Image'),
          onPressed: confirmImage,
        )
      ],
    );
  }

  Widget getImage() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.9 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: widget.image);
  }

  Widget getHeader() {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Positioned(left: 10, child: BackButton()),
        Align(
            child: Text(
          "Confirm Align",
          textAlign: TextAlign.center,
          textScaleFactor: 1.5,
        )),
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
                children: [getHeader(), getImage(), getBottomButtons()])));
  }
}
