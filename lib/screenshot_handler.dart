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

  ScreenshotHandler._internal();

  Future<void> saveTextResults(Widget textWidget) async {
    Uint8List image = await screenshotController.captureFromWidget(textWidget);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path + '/textResults.png';
    await writeToFile(image, tempPath);

    textResultsPath = tempPath;
  }

  void saveAllFilesToCameraRoll() {
    GallerySaver.saveImage(sideResultsPath!);
    GallerySaver.saveImage(frontResultsPath!);
    GallerySaver.saveImage(textResultsPath!);
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
    Widget resultScreen = ResultsWidgets.getImageInfo(width, height, imagePath);

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
