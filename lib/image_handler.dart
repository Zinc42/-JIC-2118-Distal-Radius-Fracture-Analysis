
import 'package:flutter/material.dart';
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
  // cm / screen pixels
  late double screenToCmRatio;

  factory ImageHandler() {
    return _instance;
  }
  
  ImageHandler._internal();

  // only need set length scale for frontal image
  void setInputScale(double? lineLength, double? lineScreenLength) {
    if (lineLength == null || lineScreenLength == null) {
      print("Input Lengths Failed to Parse");
      screenToCmRatio = 1;
      return;
    }
    screenToCmRatio = lineLength / lineScreenLength;
  }

  void setImageScreenDims(double width, double height) {
    imageDisplayWidth = width;
    imageDisplayHeight = height;
  }

  double getPixelToCm() {
    if (frontalLineLength == null || frontalLineScreenLength == null) {
      print("Missing Scale Input Values");
      return 0;
    } else {
      return frontalLineLength! / frontalLineScreenLength!;
    }
  }

  void setFrontImageScreenRatio(double frontImageWidth) {
    if (imageDisplayWidth == null) {
      print("Image Display Size Not Set");
      return;
    }
    imageToScreenRatioFront = imageDisplayWidth! / frontImageWidth;
  }

  void setLateralImageScreenRatio(double lateralImageWidth) {
    if (imageDisplayWidth == null) {
      print("Image Display Size Not Set");
      return;
    }
    imageToScreenRatioLateral = imageDisplayWidth! / lateralImageWidth;
  }

  double getImageDisplayWidth() {
    if (imageDisplayHeight == null) {
      print("Image Display Dims not Set");
      return 0;
    }
    return imageDisplayWidth!;
  }
  
  double getImageDisplayHeight() {
    if (imageDisplayHeight == null) {
      print("Image Display Dims not Set");
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

  // calculates Radial Inclination (angle of inclination) in DEGREES
  double getRadialInclination() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      return atan(radialStyloidFrontY / radialStyloidFrontX) * 180 / pi;
    }
  }

  // calcualtes Radial Height - currently still in pixels, not converted to IRL measurements
  double getRadialHeight() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      return minArticularSurfaceY - radialStyloidFrontY;
    }
  }

  // calculates Volar Tilt (angle of inclination) in DEGREES
  double getVolarTilt() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      return atan(lateralUpperY / lateralUpperX) * 180 / pi;
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