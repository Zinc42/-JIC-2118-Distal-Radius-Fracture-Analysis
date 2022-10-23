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
  late double radialStyloidX = 100;
  late double radialStyloidY = 200;

  // coordinates of minArticularSurface (in Pixels) (set to random default values for now)
  late double minArticularSurfaceX = 300;
  late double minArticularSurfaceY = 400;

  factory ImageHandler() {
    return _instance;
  }
  
  ImageHandler._internal();

  String getNewFileID() {
    String newFileID = fileID.toString();
    fileID++;
    return newFileID;
  }

  // Set coordinates of key points.
  void setRadialStyloid(double x, double y) {
    radialStyloidX = x;
    radialStyloidY = y;
  }

  void setMinArticularSurface(double x, double y) {
    minArticularSurfaceX = x;
    minArticularSurfaceY = y;
  }

  double getMinArticularSurfaceX() {
    return minArticularSurfaceX;
  }

  double getMinArticularSurfaceY() {
    return minArticularSurfaceY;
  }

  double getRadialStyloidX() {
    return radialStyloidX;
  }

  double getRadialStyloidY() {
    return radialStyloidY;
  }

  // calculates Radial Inclucnation (angle of inclination) in DEGREES
  double getRadialInclination() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      print(atan(radialStyloidY / radialStyloidX));
      return atan(radialStyloidY / radialStyloidX) * 180 / pi;
    }
  }

  double getRadialHeight() {
    if (isMissingPoints()) {
      print("Missing Point Coords");
      return 0;
    } else {
      return minArticularSurfaceY - radialStyloidY;
    }
  }

  bool isMissingPoints() {
    return radialStyloidX == null || radialStyloidY == null || minArticularSurfaceX == null || minArticularSurfaceY == null;
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