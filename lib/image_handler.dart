import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';
import "dart:io";

// singleton Image Handler class
class ImageHandler {
  static final ImageHandler _instance = ImageHandler._internal();

  // stores paths to image files
  String? frontImagePath;
  String? sideImagePath;

  // boolean value indicating which image is currently
  // selected for upload
  bool isFrontImage = true;

  // coordinates of Radial Styloid (in Image Pixels) (set to random default values for now)
  late double radialStyloidFrontX = 200;
  late double radialStyloidFrontY = 400;

  // coordinates of minArticularSurface (in Image Pixels) (set to random default values for now)
  late double minArticularSurfaceX = 400;
  late double minArticularSurfaceY = 800;
 
  // TODO：update variable names to reflect actual names for lateral projection

  // coordinates of upper point in Lateral projection (in Image Pixels) (set to random default values for now)
  late double lateralUpperX = 300;
  late double lateralUpperY = 500;

  // coordinates of lower point in Lateral projection (in Image Pixels) (set to random default values for now)
  late double lateralLowerX = 700;
  late double lateralLowerY = 700;

  // length of the scale line(s) in cm (IRL)
  double? frontalLineLength;
  // length of the scale line(s) in Image
  double? frontalLineScreenLength;

  // width and height of currently displayed image widget (in Screen Pixels)
  double? imageDisplayWidth;
  double? imageDisplayHeight;

  // screen pixels / image pixels
  late double imageToScreenRatioFront;
  late double imageToScreenRatioLateral;

  bool isSetImageToScreenRatio = false;

  // cm / screen pixels
  late double screenToCmRatio;

  factory ImageHandler() {
    return _instance;
  }
  
  ImageHandler._internal();

  void reset() {
    // delete image files
    if (frontImagePath != null) {
      File imageFile = File(frontImagePath!);
      imageFile.deleteSync();
    }
    if (sideImagePath != null) {
      File imageFile = File(sideImagePath!);
      imageFile.deleteSync();
    }

    frontImagePath = null;
    sideImagePath = null;

    // screen/image/cm ratios and values
    isSetImageToScreenRatio = false;
    imageToScreenRatioFront = 1;
    imageToScreenRatioLateral = 1;
    screenToCmRatio = 1;
    frontalLineLength = null;
    frontalLineScreenLength = null;

    // reset point values to defaults (probably not needed)
    setRadialStyloidFront(200, 400);
    setMinArticularSurface(400, 800);
    setlateralUpper(300, 500);
    setlateralLower(700, 700);

    // not sure if this is needed, since this is set throughout the app
    // as needed, but will just reset to original default value
    isFrontImage = true;
  }

  // only need set length scale for frontal image
  // set in image_confirm screen
  void setInputScale(double? lineLength, double? lineScreenLength) {
    if (lineLength == null || lineScreenLength == null) {
      // print("Input Lengths Failed to Parse");
      screenToCmRatio = 1;
      return;
    }
    frontalLineLength = lineLength;
    frontalLineScreenLength = lineScreenLength;
    screenToCmRatio = lineLength / lineScreenLength;
  }

  // set in results_screen
  void setImageScreenDims(double width, double height) {
    imageDisplayWidth = width;
    imageDisplayHeight = height;
  }

  double getPixelToCm() {
    if (frontalLineLength == null || frontalLineScreenLength == null) {
      // print("Missing Scale Input Values");
      return 0;
    } else {
      return frontalLineLength! / frontalLineScreenLength!;
    }
  }

  void setFrontImageScreenRatio(double frontImageWidth) {
    if (imageDisplayWidth == null) {
      // print("Image Display Size Not Set");
      return;
    }
    imageToScreenRatioFront = imageDisplayWidth! / frontImageWidth;
  }

  void setLateralImageScreenRatio(double lateralImageWidth) {
    if (imageDisplayWidth == null) {
      // print("Image Display Size Not Set");
      return;
    }
    imageToScreenRatioLateral = imageDisplayWidth! / lateralImageWidth;
  }

  double getImageDisplayWidth() {
    if (imageDisplayHeight == null) {
      // print("Image Display Dims not Set");
      return 0;
    }
    return imageDisplayWidth!;
  }
  
  double getImageDisplayHeight() {
    if (imageDisplayHeight == null) {
      // print("Image Display Dims not Set");
      return 0;
    }
    return imageDisplayHeight!;
  }

  // Set coordinates of key points (in IMAGE PIXELS).
  void setRadialStyloidFront(double x, double y) {
    radialStyloidFrontX = x;
    radialStyloidFrontY = y;
  }

  void setMinArticularSurface(double x, double y) {
    minArticularSurfaceX = x;
    minArticularSurfaceY = y;
  }

  void setlateralUpper(double x, double y) {
    lateralUpperX = x;
    lateralUpperY = y;
  }

  void setlateralLower(double x, double y) {
    lateralLowerX = x;
    lateralLowerY = y;
  }

  // getters for coords of key points (in SCREEN PIXELS)
  double getMinArticularSurfaceX() {
    return minArticularSurfaceX * imageToScreenRatioFront;
  }

  double getMinArticularSurfaceY() {
    return minArticularSurfaceY * imageToScreenRatioFront;
  }

  double getRadialStyloidFrontX() {
    return radialStyloidFrontX * imageToScreenRatioFront;
  }

  double getRadialStyloidFrontY() {
    return radialStyloidFrontY * imageToScreenRatioFront;
  }

  double getLateralUpperX() {
    return lateralUpperX * imageToScreenRatioLateral;
  }

  double getLateralUpperY() {
    return lateralUpperY * imageToScreenRatioLateral;
  }

  double getLateralLowerX() {
    return lateralLowerX * imageToScreenRatioLateral;
  }

  double getLateralLowerY() {
    return lateralLowerY * imageToScreenRatioLateral;
  }

  // calculates Radial Inclination in DEGREES
  double getRadialInclination() {
    if (isMissingPoints()) {
      // print("Missing Point Coords");
      return 0;
    } else {
      Vector2 hVector = Vector2(radialStyloidFrontX - minArticularSurfaceX, 0);
      Vector2 aVector = Vector2(radialStyloidFrontX - minArticularSurfaceX, radialStyloidFrontY - minArticularSurfaceY);
      return hVector.angleTo(aVector) * 180 / pi;
    }
  }

  // calcualtes Radial Height - currently still in pixels, not converted to IRL measurements
  double getRadialHeight() {
    if (isMissingPoints()) {
      // print("Missing Point Coords");
      return 0;
    } else {
      return (minArticularSurfaceY - radialStyloidFrontY) * imageToScreenRatioFront * screenToCmRatio;
    }
  }

  // calculates Volar Tilt in DEGREES
  double getVolarTilt() {
    if (isMissingPoints()) {
      // print("Missing Point Coords");
      return 0;
    } else {
      Vector2 hVector = Vector2(lateralUpperX - lateralLowerX, 0);
      Vector2 aVector = Vector2(lateralUpperX - lateralLowerX, lateralUpperY - lateralLowerY);
      return hVector.angleTo(aVector) * 180 / pi;
    }
  }

  bool isMissingPoints() {
    return radialStyloidFrontX == null || radialStyloidFrontY == null || minArticularSurfaceX == null || minArticularSurfaceY == null;
  }

  // basic getters/setters
  void setCurrImagepath(String newImagePath) {
    if (isFrontImage) {
      setFrontImagePath(newImagePath);
    } else {
      setSideImagePath(newImagePath);
    }
  }

  // gets the current image path based on the currnt "mode"/image
  // that is set in isFrontImage
  String? getCurrImagepath() {
    if (isFrontImage) {
      return frontImagePath;
    } else {
      return sideImagePath;
    }
  }

  void setFrontImagePath(String newFrontImagePath) {
    frontImagePath = newFrontImagePath;
  }

  void setSideImagePath(String newSideImagePath) {
    sideImagePath = newSideImagePath;
  }

  bool isMissingImages() {
    return frontImagePath == null || sideImagePath == null;
  }

  bool getIsFrontImage() {
    return isFrontImage;
  }
  
}