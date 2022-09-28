class ImageHandler {
  static final ImageHandler _instance = ImageHandler._internal();

  String? frontImagePath;
  String? sideImagePath;
 
  factory ImageHandler() {
    return _instance;
  }
  
  ImageHandler._internal();

  void setFrontImagePath(String newFrontImagePath) {
    frontImagePath = newFrontImagePath;
  }

  void setSideImagePath(String newSideImagePath) {
    sideImagePath = newSideImagePath;
  }

  bool isMissingImages() {
    return frontImagePath == null || sideImagePath == null;
  }
  
}