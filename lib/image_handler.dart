import 'dart:math';

// singleton Image Handler class
class ImageHandler {
  static final ImageHandler _instance = ImageHandler._internal();

  // stores paths to image files
  String? frontImagePath;
  String? sideImagePath;

  // boolean value indicating which image is currently
  // selected for upload
  bool isFrontImage = true;

  // a number tag to add at the end of file paths/names so that
  // new images can be saved (if user retakes an image)
  int fileID = 0;

  // coordinates of Radial Styloid (in Pixels) (set to random default values for now)
  late double RadialStyloidFrontX = 100;
  late double RadialStyloidFrontY = 200;

  // coordinates of minArticularSurface (in Pixels) (set to random default values for now)
  late double minArticularSurfaceX = 300;
  late double minArticularSurfaceY = 400;

  // length of the scale line(s) in cm (IRL)
  double? frontalLineLength;
  // length of the scale line(s) in pixels
  double? frontalLineScreenLength;
 
  // TODO：update variable names to reflect actual names for lateral projection

  // coordinates of upper point in Lateral projection (in Pixels) (set to random default values for now)
  late double lateralUpperX = 100;
  late double lateralUpperY = 200;

  // coordinates of lower point in Lateral projection (in Pixels) (set to random default values for now)
  late double lateralLowerX = 300;
  late double lateralLowerY = 400;

  factory ImageHandler() {
    return _instance;
  }
  
  ImageHandler._internal();

  // only need scale for frontal image
  void setInputScale(double? lineLength, double? lineScreenLength) {
    frontalLineLength = lineLength;
    frontalLineScreenLength = lineScreenLength;
  }

  // get pixelToCm ratio (cm / pixels)
  double getPixelToCm() {
    if (frontalLineLength == null || frontalLineScreenLength == null) {
      print("Missing Scale Input Values");
      return 0;
    } else {
      return frontalLineLength! / frontalLineScreenLength!;
    }
  }

  String getNewFileID() {
    String newFileID = fileID.toString();
    fileID++;
    return newFileID;
  }

  // Set coordinates of key points.
  void setRadialStyloidFront(double x, double y) {
    RadialStyloidFrontX = x;
    RadialStyloidFrontY = y;
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

  // getters for coords of key poits
  double getMinArticularSurfaceX() {
    return minArticularSurfaceX;
  }

  double getMinArticularSurfaceY() {
    return minArticularSurfaceY;
  }

  double getRadialStyloidFrontX() {
    return RadialStyloidFrontX;
  }

  double getRadialStyloidFrontY() {
    return RadialStyloidFrontY;
  }

  double getLateralUpperX() {
    return lateralUpperX;
  }

  double getLateralUpperY() {
    return lateralUpperY;
  }

  double getLateralLowerX() {
    return lateralLowerX;
  }

  double getLateralLowerY() {
    return lateralLowerY;
  }

  // calculates Radial Inclination (angle of inclination) in DEGREES
  double getRadialInclination() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      return atan(RadialStyloidFrontY / RadialStyloidFrontX) * 180 / pi;
    }
  }

  // calcualtes Radial Height - currently still in pixels, not converted to IRL measurements
  double getRadialHeight() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      return minArticularSurfaceY - RadialStyloidFrontY;
    }
  }

  bool isMissingPoints() {
    return RadialStyloidFrontX == null || RadialStyloidFrontY == null || minArticularSurfaceX == null || minArticularSurfaceY == null;
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