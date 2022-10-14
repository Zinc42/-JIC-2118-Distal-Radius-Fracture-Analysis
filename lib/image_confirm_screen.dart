import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';

import 'package:distal_radius/image_upload_screen.dart';
import 'package:distal_radius/menu_screen.dart';
import 'package:flutter/services.dart';
import 'image_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:crop/crop.dart';

class ImageConfirmScreen extends StatefulWidget {
  final RawImage image;

  // added originalPath as a parameter so pass the original path
  // of the image files to then write new file/image into.
  final String originalPath;

  const ImageConfirmScreen({super.key, required this.image, required this.originalPath});

  @override
  State<ImageConfirmScreen> createState() => _ImageConfirmScreen();
}

class _ImageConfirmScreen extends State<ImageConfirmScreen> {

  ImageHandler imageHandler = ImageHandler();

  final textController = TextEditingController();

  final double lineScreenLength = 150;

  void cancelImage() {
    Navigator.of(context).popUntil(ModalRoute.withName(ImageUploadScreen.id));
  }

  void confirmImage() async {
    // set scale input (length of lines in px and cm stored in ImageHandler)
    // sets value to null is nothing is entered
    imageHandler.setInputScale(double.tryParse(textController.text), lineScreenLength);

    // overwrites original image path with new image
    writeToFile((await widget.image.image!.toByteData(format: ImageByteFormat.png))!, widget.originalPath);

    // updates path to images in imageHandler
    imageHandler.setCurrImagepath(widget.originalPath);

    if(!mounted) return;
    Navigator.of(context).popUntil(ModalRoute.withName(MenuScreen.id));
  }

  // function write new image data to the same file path as old uncropped image
  Future<File> writeToFile(ByteData data, String path) {

    // need to uncomment this for overwriting to take plate
    // otherwise, the uncropped image is unchanged.
    imageCache.clear();

    final buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), flush: true);
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.image,
            Container(
              alignment: Alignment.center,
              height: lineScreenLength,
              child: const VerticalDivider(
                color: Colors.red,
                width: 5,
                thickness: 5,
                indent: 0,
                endIndent: 0,
              ),
            ),
          ]
        ),
    );
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
          )
        ),
      ],
    );
  }
  
  Widget getScaleInputField() {
    final screenWidth = MediaQuery.of(context).size.width;

    // text field only accepts strings that can parse into a double (i.e. valid decimal values)
    return Container(
      width: screenWidth - 60,
      height: 40,
      child: TextField(
        controller: textController,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Length of Red Line (cm)"),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {
              print(e);
            }
            return oldValue;
          }),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 35.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getHeader(), 
                const SizedBox(height: 20),
                getImage(), 
                const SizedBox(height: 20),
                getScaleInputField(),
                const SizedBox(height: 10),
                getBottomButtons(),
              ]
            )
          )
        )
      );
  }
}
