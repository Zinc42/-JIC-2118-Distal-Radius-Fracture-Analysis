import 'dart:typed_data';
import 'dart:io';

import 'package:distal_radius/image_handler.dart';
import 'package:distal_radius/image_results_screen.dart';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ScreenshotHandler {
  static final ScreenshotHandler _instance = ScreenshotHandler._internal();
  ImageHandler imageHandler = ImageHandler();
  ScreenshotController screenshotController = ScreenshotController();

  String? sideResultsPath;
  String? frontResultsPath;
  String? textResultsPath;

  factory ScreenshotHandler() {
    return _instance;
  }

  String? getSideResultsPath() {
    return sideResultsPath;
  }

  String? getFrontResultsPath() {
    return frontResultsPath;
  }

  String? getTextResultsPath() {
    return textResultsPath;
  }

  ScreenshotHandler._internal();

  Future<void> saveTextResults(Widget textWidget) async {
    Widget textContainer = Container(
        color: Colors.white,
        height: 600.0,
        child: Column(children: [
          const Text("Text Results",
              style: TextStyle(color: Colors.black, fontSize: 20.0)),
          const SizedBox(height: 20),
          textWidget
        ]));
    Uint8List image =
        await screenshotController.captureFromWidget(textContainer);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + '/textResults.png';
    await writeToFile(image, tempPath);

    textResultsPath = tempPath;
  }

  Future<bool> saveAllFilesToCameraRoll() async {
    bool? savedSide = await GallerySaver.saveImage(sideResultsPath!);
    bool? savedFront = await GallerySaver.saveImage(frontResultsPath!);
    bool? savedText = await GallerySaver.saveImage(textResultsPath!);

    return savedSide! && savedFront! && savedText!;
  }

  Future<void> saveBothImages(height, width) async {
    bool oldIsFront = imageHandler.isFrontImage;
    imageHandler.isFrontImage = true;
    await saveImageResults(width, height, imageHandler.frontImagePath);
    imageHandler.isFrontImage = false;
    await saveImageResults(width, height, imageHandler.sideImagePath);

    imageHandler.isFrontImage = oldIsFront;
  }

  Future<void> saveImageResults(width, height, imagePath) async {
    Widget resultScreen = Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: ResultsWidgets.getImageInfo(width, height, imagePath));

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    tempPath +=
        (imageHandler.isFrontImage) ? '/frontResults.png' : '/sideResults.png';

    Uint8List image =
        await screenshotController.captureFromWidget(resultScreen);
    await writeToFile(image, tempPath);

    if (imageHandler.isFrontImage) {
      frontResultsPath = tempPath;
    } else {
      sideResultsPath = tempPath;
    }
  }

  Future<void> writeToFile(Uint8List data, path) async {
    File(path).writeAsBytes(data, flush: true);
  }
}
